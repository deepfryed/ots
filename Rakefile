require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/contrib/sshpublisher'
require 'fileutils'
include FileUtils

NAME              = "ots"
AUTHORS           = ["Bharane Rathna"]
EMAIL             = "deepfryed@gmail.com"
DESCRIPTION       = "libots interface for ruby"
RUBYFORGE_PROJECT = "ots"
HOMEPATH          = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
BIN_FILES         = %w( )

VERS              = "0.1.0"
REV = File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = [
	'--title', "#{NAME} documentation",
	"--charset", "utf-8",
	"--opname", "index.html",
	"--line-numbers",
	"--main", "README",
	"--inline-source",
]

task :default => [:test]
task :package => [:clean]

Rake::TestTask.new("test") do |t|
	t.libs   << "test"
	t.pattern = "test/**/*_test.rb"
	t.verbose = true
end

spec = Gem::Specification.new do |s|
	s.name              = NAME
	s.version           = VERS
	s.platform          = Gem::Platform::RUBY
	s.has_rdoc          = true
	s.extra_rdoc_files  = ["README" ]
	s.rdoc_options     += RDOC_OPTS + ['--exclude', '^(examples|extras)/']
	s.summary           = DESCRIPTION
	s.description       = DESCRIPTION
	s.authors           = AUTHORS
	s.email             = EMAIL
	s.homepage          = HOMEPATH
	s.executables       = BIN_FILES
	s.rubyforge_project = RUBYFORGE_PROJECT
	s.bindir            = "bin"
	s.require_path      = "lib"
	s.test_files        = Dir["test/*_test.rb"]
	s.required_ruby_version = '~> 1.8'

	s.files = %w(README Rakefile) +
		Dir.glob("{bin,doc,test,lib,templates,generator,extras,website,script}/**/*") + 
		Dir.glob("*.{h,c,rb}") +
		Dir.glob("examples/**/*.rb") +
		Dir.glob("tools/*.rb") +
		Dir.glob("ext/*.{h,c}")

	s.extensions = ["ext/extconf.rb"]
end

Rake::GemPackageTask.new(spec) do |p|
	p.need_tar = true
	p.gem_spec = spec
end

task :install do
	name = "#{NAME}-#{VERS}.gem"
	sh %{rake package}
	sh %{sudo gem install pkg/#{name}}
end

task :uninstall => [:clean] do
	sh %{sudo gem uninstall #{NAME}}
end


Rake::RDocTask.new do |rdoc|
	rdoc.rdoc_dir = 'html'
	rdoc.options += RDOC_OPTS
	rdoc.template = "resh"
	if ENV['DOC_FILES']
		rdoc.rdoc_files.include(ENV['DOC_FILES'].split(/,\s*/))
	else
		rdoc.rdoc_files.include('README')
		rdoc.rdoc_files.include('lib/**/*.rb')
		rdoc.rdoc_files.include('**/*.c')
	end
end

desc "Publish to RubyForge"
task :rubyforge => [:rdoc, :package] do
	require 'rubyforge'
	Rake::RubyForgePublisher.new(RUBYFORGE_PROJECT, 'takiuchi').upload
end

desc 'Package and upload the release to rubyforge.'
task :release => [:clean, :package] do |t|
	v = ENV["VERSION"] or abort "Must supply VERSION=x.y.z"
	abort "Versions don't match #{v} vs #{VERS}" unless v == VERS
	pkg = "pkg/#{NAME}-#{VERS}"

	require 'rubyforge'
	rf = RubyForge.new.configure
	puts "Logging in"
	rf.login

	c = rf.userconfig
	c["preformatted"] = true

	files = [
		"#{pkg}.tgz",
		"#{pkg}.gem"
	].compact

	puts "Releasing #{NAME} v. #{VERS}"
	rf.add_release RUBYFORGE_PROJECT, NAME, VERS, *files
end

desc 'Show information about the gem.'
task :debug_gem do
	puts spec.to_ruby
end

desc 'Update gem spec'
task :gemspec do
  open("#{NAME}.gemspec", 'w') do |file|
    file.write spec.to_ruby
  end
end
