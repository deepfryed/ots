#include <ruby.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libots-1/ots/libots.h>

#define ID_CONST_GET rb_intern("const_get")
#define CONST_GET(scope, constant) (rb_funcall(scope, ID_CONST_GET, 1, rb_str_new2(constant)))

static VALUE rb_cOTS;
static VALUE eLoadError;
static VALUE eRuntimeError;
static VALUE eArgumentError;

typedef struct {
  gchar *word;    /* the word */
  gchar *stem;    /*stem of the word*/
  gint occ;     /* how many times have we seen this word in the text? */
} OtsWordEntery;


/* helpers */

OtsArticle* get_article(VALUE self, gboolean error_on_missing) {
  VALUE rb_article_object = rb_iv_get(self, "@article");
  if (rb_article_object == Qnil) {
    if (error_on_missing)
      rb_raise(eRuntimeError, "libots document not initialized properly. Did you forget to parse content ?");
    else
      return NULL;
  }
  return (OtsArticle *)DATA_PTR(rb_article_object);
}

void rb_ots_free_article(VALUE self) {
  OtsArticle *article = DATA_PTR(rb_iv_get(self, "@article"));
  ots_free_article(article);
}

/* ruby libots methods/wrappers */

VALUE rb_ots_init(VALUE self) {
  OtsArticle *article = get_article(self, FALSE);
  VALUE dict = Qnil;
  if (article != NULL) {
    dict = rb_iv_get(self, "@dict");
    ots_free_article(article);
  }
  article = ots_new_article();
  rb_iv_set(self, "@article", Data_Wrap_Struct(rb_cObject, 0, 0, article));
  rb_iv_set(self, "@dict", dict);
  return self;
}

VALUE rb_ots_load_dictionary(VALUE self, VALUE dict) {
  char *dict_cstr = "en";
  if (dict != Qnil) dict_cstr = RSTRING_PTR(dict);

  OtsArticle *article = get_article(self, FALSE);
  if (article == NULL) {
    rb_ots_init(self);
    article = get_article(self, TRUE);
  }

  if (!ots_load_xml_dictionary(article, (unsigned const char *)dict_cstr)) {
    rb_ots_free_article(self);
    rb_raise(eLoadError, "Could not find dictionary file: %s", dict_cstr);
  }

  rb_iv_set(self, "@dict", dict);
  return Qtrue;
}

VALUE rb_ots_parse_string(VALUE self, VALUE string) {
  const unsigned char *string_cstr = (const unsigned char *)RSTRING_PTR(string);
  size_t string_len = RSTRING_LEN(string);

  rb_ots_init(self);
  rb_ots_load_dictionary(self, rb_iv_get(self, "@dict"));
  OtsArticle *article = get_article(self, TRUE);
  ots_parse_stream(string_cstr, string_len, article);
  ots_grade_doc(article);
  return Qtrue;
}

VALUE rb_ots_highlight_lines(VALUE self, int lines) {
  OtsArticle *article = get_article(self, TRUE);
  ots_highlight_doc_lines(article, lines);
  return Qtrue;
}

VALUE rb_ots_highlight_percent(VALUE self, int percent) {
  OtsArticle *article = get_article(self, TRUE);
  ots_highlight_doc(article, percent);
  return Qtrue;
}

VALUE rb_ots_article_title(VALUE self) {
  OtsArticle *article = get_article(self, TRUE);
  if (article->title != NULL)
    return rb_str_new(article->title, strlen(article->title));
  else
    return Qnil;
}

VALUE rb_ots_article_keywords(VALUE self) {
  OtsArticle *article = get_article(self, TRUE);
  GList* words = article->ImpWords;
  VALUE iwords = rb_ary_new();
  while (words != NULL) {
    OtsWordEntery *data = (OtsWordEntery *)words->data;
    if (data != NULL && strlen(data->word) > 0)
      rb_ary_push(iwords, rb_str_new(data->word, strlen(data->word)));
    words = words->next;
  }

  return iwords;
}

VALUE rb_ots_get_highlighted_lines(VALUE self) {
  OtsArticle *article = get_article(self, TRUE);
  OtsSentence *sentence;
  GList *curr_line = article->lines;
  VALUE hlt_lines = rb_ary_new();

  while (curr_line != NULL) {
    sentence = (OtsSentence *)curr_line->data;
    if (sentence->selected) {
      size_t len;
      unsigned char* content = ots_get_line_text(sentence, TRUE, &len);
      VALUE hlt_line = rb_hash_new();
      rb_hash_aset(hlt_line, ID2SYM(rb_intern("sentence")), rb_str_new((char *)content, len));
      rb_hash_aset(hlt_line, ID2SYM(rb_intern("score")), LONG2FIX(sentence->score));
      rb_ary_push(hlt_lines, hlt_line);
    }
    curr_line = g_list_next(curr_line);
  }

  return hlt_lines;
}

VALUE rb_summarize(VALUE self, VALUE options) {

  VALUE lines = rb_hash_aref(options, ID2SYM(rb_intern("lines")));
  VALUE percent = rb_hash_aref(options, ID2SYM(rb_intern("percent")));

  if (lines != Qnil && percent != Qnil) {
    rb_ots_free_article(self);
    rb_raise(eArgumentError, "Cannot summarize on :lines & :percent, only one is allowed");
  }
  else if (lines == Qnil && percent == Qnil) {
    rb_ots_free_article(self);
    rb_raise(eArgumentError, "Need either :lines or :percent to summarize");
  }

  if (lines != Qnil)
    rb_ots_highlight_lines(self, FIX2LONG(lines));
  else if (percent != Qnil) 
    rb_ots_highlight_percent(self, FIX2LONG(percent));
  return rb_ots_get_highlighted_lines(self);
}

/* init */

void Init_ots(void) {
    eLoadError     = CONST_GET(rb_mKernel, "LoadError");
    eRuntimeError  = CONST_GET(rb_mKernel, "RuntimeError");
    eArgumentError = CONST_GET(rb_mKernel, "ArgumentError");
    rb_cOTS = rb_define_class("OTS", rb_cObject);
    rb_define_method(rb_cOTS, "load_dictionary", rb_ots_load_dictionary, 1);
    rb_define_method(rb_cOTS, "parse", rb_ots_parse_string, 1);
    rb_define_method(rb_cOTS, "highlight_lines", rb_ots_highlight_lines, 1);
    rb_define_method(rb_cOTS, "highlight_percent", rb_ots_highlight_percent, 1);
    rb_define_method(rb_cOTS, "highlighted_content", rb_ots_get_highlighted_lines, 0);
    rb_define_method(rb_cOTS, "summarize", rb_summarize, 1);
    rb_define_method(rb_cOTS, "title", rb_ots_article_title, 0);
    rb_define_method(rb_cOTS, "keywords", rb_ots_article_keywords, 0);
}
