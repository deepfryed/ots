require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/extensiontask'

CLEAN << FileList[ 'ext/Makefile', 'ext/ots.so' ]

begin
  require 'jeweler'
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Jeweler::Tasks.new do |gem|
  gem.name        = 'ots'
  gem.summary     = 'Open Text Summarizer interface for Ruby.'
  gem.description = 'Ruby interface to libots libraries for unix.'
  gem.email       = 'deepfryed@gmail.com'
  gem.homepage    = 'http://github.com/deepfryed/ots'
  gem.authors     = ['Bharanee Rathna']
  
  gem.add_development_dependency 'shoulda', '>= 2.10'
  
  gem.files = FileList[
    'lib/**/*.rb',
    'ext/*.{h,c}',
    'VERSION',
    'README'
  ]
  gem.extensions  = FileList[ 'ext/**/extconf.rb' ]
  gem.test_files  = FileList[ 'test/**/*_test.rb' ]
end

Jeweler::GemcutterTasks.new

Rake::ExtensionTask.new do |ext|
  ext.name    = 'ots'
  ext.ext_dir = 'ext'
  ext.lib_dir = 'ext'
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ots #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :test    => [ :compile, :check_dependencies ]
task :default => :test
