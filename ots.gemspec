# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ots}
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = %q{2012-01-25}
  s.description = %q{Ruby interface to libots libraries for unix.}
  s.email = ["deepfryed@gmail.com"]
  s.extensions = ["ext/extconf.rb"]
  s.files = ["ext/ots.c", "ext/libots/text.c", "ext/libots/grader-tf.c", "ext/libots/stemmer.c", "ext/libots/article.c", "ext/libots/grader-tc.c", "ext/libots/html.c", "ext/libots/grader.c", "ext/libots/relations.c", "ext/libots/parser.c", "ext/libots/dictionary.c", "ext/libots/highlighter.c", "ext/libots/wordlist.c", "ext/ots.h", "ext/version.h", "ext/libots/grader-tc.h", "ext/libots/libots.h", "ext/extconf.rb", "test/test_article.rb", "test/test_ots.rb", "test/helper.rb", "README.md", "CHANGELOG", "dictionaries/cy.xml", "dictionaries/tr.xml", "dictionaries/fr.xml", "dictionaries/yi.xml", "dictionaries/ms.xml", "dictionaries/ia.xml", "dictionaries/lv.xml", "dictionaries/gl.xml", "dictionaries/cs.xml", "dictionaries/sv.xml", "dictionaries/is.xml", "dictionaries/fi.xml", "dictionaries/bg.xml", "dictionaries/uk.xml", "dictionaries/et.xml", "dictionaries/tl.xml", "dictionaries/da.xml", "dictionaries/it.xml", "dictionaries/ru.xml", "dictionaries/nl.xml", "dictionaries/eo.xml", "dictionaries/mi.xml", "dictionaries/ro.xml", "dictionaries/pl.xml", "dictionaries/ga.xml", "dictionaries/he.xml", "dictionaries/mt.xml", "dictionaries/eu.xml", "dictionaries/hu.xml", "dictionaries/en.xml", "dictionaries/de.xml", "dictionaries/el.xml", "dictionaries/pt.xml", "dictionaries/ca.xml", "dictionaries/es.xml", "dictionaries/nn.xml", "dictionaries/id.xml"]
  s.homepage = %q{http://github.com/deepfryed/ots}
  s.require_paths = ["lib"]
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
