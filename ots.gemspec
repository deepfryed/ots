# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ots}
  s.version = "0.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bharanee Rathna"]
  s.date = %q{2012-01-09}
  s.description = %q{Ruby interface to libots libraries for unix.}
  s.email = ["deepfryed@gmail.com"]
  s.extensions = ["ext/extconf.rb"]
  s.files = ["ext/ots.c", "ext/ots.h", "ext/version.h", "ext/extconf.rb", "test/test_article.rb", "test/test_ots.rb", "test/helper.rb", "README.md"]
  s.homepage = %q{http://github.com/deepfryed/ots}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Open Text Summarizer interface for Ruby.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
