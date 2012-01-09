require 'date'
require 'pathname'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/extensiontask'

$rootdir = Pathname.new(__FILE__).dirname
$gemspec = Gem::Specification.new do |s|
  s.name              = "ots"
  s.version           = "0"           # modify ext/version.h
  s.date              = Date.today    
  s.authors           = ["Bharanee Rathna"]
  s.email             = ["deepfryed@gmail.com"]
  s.summary           = "Open Text Summarizer interface for Ruby."
  s.description       = "Ruby interface to libots libraries for unix."
  s.homepage          = "http://github.com/deepfryed/ots"
  s.files             = Dir["ext/**/*.{cc,c,h}"] + Dir["{ext,test}/*.rb"] + %w(README.md)
  s.extensions        = %w(ext/extconf.rb)
  s.require_paths     = %w(lib)
end

desc 'Generate ots gemspec'
task :gemspec do 
  $gemspec.date    = Date.today
  $gemspec.version = File.read($rootdir + 'ext/version.h').scan(/[\d.]+/).first
  File.open('ots.gemspec', 'w') {|fh| fh.write($gemspec.to_ruby)}
end

Rake::ExtensionTask.new do |ext|
  ext.name    = 'ots'
  ext.ext_dir = 'ext'
  ext.lib_dir = 'ext'
end

Rake::TestTask.new(:test) do |test|
  test.libs   << 'ext' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task test:    [:compile]  
task default: :test
