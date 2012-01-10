#include "ots.h"
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>

static VALUE mOTS, cArticle;

static void article_free(OtsArticle *article) {
    if (article)
      ots_free_article(article);
}

VALUE article_allocate(VALUE klass) {
    OtsArticle *article = ots_new_article();
    return Data_Wrap_Struct(klass, 0, article_free, article);
}

OtsArticle* article_handle(VALUE self) {
    OtsArticle *article = 0;
    Data_Get_Struct(self, OtsArticle, article);
    if (!article)
        rb_raise(rb_eArgError, "invalid OTS::Article instance");
    return article;
}

void article_load_dictionary(OtsArticle *article, char *name) {
  if (!ots_load_xml_dictionary(article, name)) {
    rb_raise(rb_eLoadError, "Could not find dictionary file: %s", name);
  }
}

VALUE article_initialize(int argc, VALUE *argv, VALUE self) {
    VALUE text, options, language, dictionary = Qnil;
    OtsArticle *article = article_handle(self);

    rb_scan_args(argc, argv, "11", &text, &options);

    language = rb_str_new2("en");

    if (TYPE(text) != T_STRING)
        rb_raise(rb_eArgError, "invalid +text+");

    if (!NIL_P(options)) {
        if (TYPE(options) != T_HASH)
            rb_raise(rb_eArgError, "invalid +options+ hash");

        dictionary = rb_hash_aref(options, ID2SYM(rb_intern("dictionary")));
        language   = rb_hash_aref(options, ID2SYM(rb_intern("language")));
    }

    if (!NIL_P(dictionary))
        article_load_dictionary(article, CSTRING(dictionary));
    else
        article_load_dictionary(article, CSTRING(language));

    ots_parse_stream(RSTRING_PTR(text), RSTRING_LEN(text), article);
    ots_grade_doc(article);

    rb_iv_set(self, "@encoding", (VALUE)rb_enc_get(text));

    return self;
}


VALUE article_summary(OtsArticle *article, rb_encoding *encoding) {
  OtsSentence *sentence;

  GList *line_ptr  = article->lines;
  VALUE summary    = rb_ary_new();

  while (line_ptr != NULL) {
    sentence = (OtsSentence *)line_ptr->data;

    if (sentence->selected) {
      size_t size;
      unsigned char* content = ots_get_line_text(sentence, TRUE, &size);

      VALUE line = rb_hash_new();
      rb_hash_aset(line, ID2SYM(rb_intern("sentence")), rb_enc_str_new((char *)content, size, encoding));
      rb_hash_aset(line, ID2SYM(rb_intern("score")),    LONG2FIX(sentence->score));
      rb_ary_push(summary, line);

      // reset this so subsequent calls work right.
      sentence->selected = FALSE;
    }

    line_ptr = g_list_next(line_ptr);
  }

  return summary;
}

VALUE article_summarize(VALUE self, VALUE options) {
    VALUE lines, percent;
    OtsArticle *article = article_handle(self);

    if (TYPE(options) != T_HASH)
        rb_raise(rb_eArgError, "expect an options hash");

    lines   = rb_hash_aref(options, ID2SYM(rb_intern("sentences")));
    percent = rb_hash_aref(options, ID2SYM(rb_intern("percent")));

    if (NIL_P(lines) && NIL_P(percent))
        rb_raise(rb_eArgError, "expect +sentences+ or +percent+");

    if (lines != Qnil)
        ots_highlight_doc_lines(article, NUM2INT(lines));
    else
        ots_highlight_doc(article, NUM2INT(percent));

    return article_summary(article, (rb_encoding *)rb_iv_get(self, "@encoding"));
}

VALUE article_topics(VALUE self) {
    OtsArticle *article = article_handle(self);

    return
        article->title ?
            rb_str_split(rb_enc_str_new2(article->title, (rb_encoding*)rb_iv_get(self, "@encoding")), ",") :
            Qnil;
}

typedef struct {
  gchar *word;    /* the word */
  gchar *stem;    /*stem of the word*/
  gint occ;     /* how many times have we seen this word in the text? */
} OtsWordEntry;


VALUE article_keywords(VALUE self) {
    OtsArticle *article = article_handle(self);
    rb_encoding *encoding = (rb_encoding*)rb_iv_get(self, "@encoding");

    VALUE words     = rb_ary_new();
    GList* word_ptr = article->ImpWords;

    while (word_ptr) {
        OtsWordEntry *data = (OtsWordEntry *)word_ptr->data;
        if (data && strlen(data->word) > 0)
            rb_ary_push(words, rb_enc_str_new2(data->word, encoding));
        word_ptr = word_ptr->next;
    }

    return words;
}

VALUE ots_parse(int argc, VALUE *argv, VALUE self) {
    VALUE article = article_allocate(cArticle);
    article_initialize(argc, argv, article);
    return article;
}

VALUE ots_languages(VALUE self) {
    DIR *dir;
    struct dirent *entry;
    VALUE languages = rb_ary_new();

    if ((dir = opendir(DICTIONARY_DIR))) {
        while ((entry = readdir(dir))) {
            // entry->d_type is not portable.
            if (strstr(entry->d_name, ".xml"))
                rb_ary_push(languages, rb_str_new(entry->d_name, strlen(entry->d_name) - 4));
        }
    }
    else {
        rb_raise(rb_eIOError, "unable to open dictionary directory: %s", strerror(errno));
    }

    closedir(dir);
    return languages;
}

/* init */

void Init_ots(void) {
    mOTS      = rb_define_module("OTS");
    cArticle  = rb_define_class_under(mOTS, "Article", rb_cObject);

    rb_define_method(cArticle, "initialize", RUBY_METHOD_FUNC(article_initialize), -1);
    rb_define_method(cArticle, "summarize",  RUBY_METHOD_FUNC(article_summarize),   1);
    rb_define_method(cArticle, "topics",     RUBY_METHOD_FUNC(article_topics),      0);
    rb_define_method(cArticle, "keywords",   RUBY_METHOD_FUNC(article_keywords),    0);

    rb_define_module_function(mOTS, "parse",     RUBY_METHOD_FUNC(ots_parse),      -1);
    rb_define_module_function(mOTS, "languages", RUBY_METHOD_FUNC(ots_languages),   0);

    rb_define_alloc_func(cArticle, article_allocate);

    rb_define_const(mOTS, "VERSION", rb_str_new2(RUBY_OTS_VERSION));
}
