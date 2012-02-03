require 'date'
require 'pathname'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/extensiontask'

$rootdir = Pathname.new(__FILE__).dirname
$gemspec = Gem::Specification.new do |s|
  s.name              = 'ots'
  s.version           = '0'           # modify ext/version.h
  s.date              = Date.today    
  s.authors           = ['Bharanee Rathna']
  s.email             = ['deepfryed@gmail.com']
  s.summary           = 'Open Text Summarizer interface for Ruby.'
  s.description       = 'Ruby interface to libots libraries for unix.'
  s.homepage          = 'http://github.com/deepfryed/ots'
  s.files             = Dir['ext/**/*.{c,h}'] + Dir['{ext,test,lib}/**/*.rb'] + %w(README.md CHANGELOG) + Dir['*/*.xml']
  s.extensions        = %w(ext/ots/extconf.rb)
  s.require_paths     = %w(lib ext)

  s.add_development_dependency('rake')
  s.add_development_dependency('rake-compiler')
end

desc 'Generate ots gemspec'
task :gemspec do 
  $gemspec.date    = Date.today
  $gemspec.version = File.read($rootdir + 'ext/ots/version.h').scan(/[\d.]+/).first
  File.open('ots.gemspec', 'w') {|fh| fh.write($gemspec.to_ruby)}
end

desc 'compile extension'
task :compile do
  Dir.chdir('ext/ots') do
    system('ruby extconf.rb && make clean && make -j2') or raise 'unable to compile ots'
  end
end

Rake::TestTask.new(:test) do |test|
  test.libs   << 'ext' << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task default: :test
task :test => [:compile]
