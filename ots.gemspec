# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ots}
  s.version = "0.5.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = %q{2012-02-03}
  s.description = %q{Ruby interface to libots libraries for unix.}
  s.email = ["deepfryed@gmail.com"]
  s.extensions = ["ext/ots/extconf.rb"]
  s.files = ["ext/ots/ots.c", "ext/ots/libots/text.c", "ext/ots/libots/grader-tf.c", "ext/ots/libots/stemmer.c", "ext/ots/libots/article.c", "ext/ots/libots/grader-tc.c", "ext/ots/libots/html.c", "ext/ots/libots/grader.c", "ext/ots/libots/relations.c", "ext/ots/libots/parser.c", "ext/ots/libots/dictionary.c", "ext/ots/libots/highlighter.c", "ext/ots/libots/wordlist.c", "ext/ots/ots.h", "ext/ots/version.h", "ext/ots/libots/grader-tc.h", "ext/ots/libots/libots.h", "ext/ots/extconf.rb", "test/test_article.rb", "test/test_ots.rb", "test/helper.rb", "test/test_grader.rb", "lib/ots.rb", "lib/ots/grader.rb", "README.md", "CHANGELOG", "dictionaries/cy.xml", "dictionaries/tr.xml", "dictionaries/fr.xml", "dictionaries/yi.xml", "dictionaries/ms.xml", "dictionaries/ia.xml", "dictionaries/lv.xml", "dictionaries/gl.xml", "dictionaries/cs.xml", "dictionaries/sv.xml", "dictionaries/is.xml", "dictionaries/fi.xml", "dictionaries/bg.xml", "dictionaries/uk.xml", "dictionaries/et.xml", "dictionaries/tl.xml", "dictionaries/da.xml", "dictionaries/it.xml", "dictionaries/ru.xml", "dictionaries/nl.xml", "dictionaries/eo.xml", "dictionaries/mi.xml", "dictionaries/ro.xml", "dictionaries/pl.xml", "dictionaries/ga.xml", "dictionaries/he.xml", "dictionaries/mt.xml", "dictionaries/eu.xml", "dictionaries/hu.xml", "dictionaries/en.xml", "dictionaries/de.xml", "dictionaries/el.xml", "dictionaries/pt.xml", "dictionaries/ca.xml", "dictionaries/es.xml", "dictionaries/nn.xml", "dictionaries/id.xml"]
  s.homepage = %q{http://github.com/deepfryed/ots}
  s.require_paths = ["lib", "ext"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Open Text Summarizer interface for Ruby.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rake-compiler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rake-compiler>, [">= 0"])
  end
end
