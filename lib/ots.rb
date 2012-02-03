require 'ots/ots'

module OTS
  DICTIONARY_PATH = File.absolute_path(File.dirname(__FILE__) + '/../dictionaries')
  # set the dictionary path, so the c extension can read files.
  # we can set this at compile time but bundler sometimes compiles the extension inside a temp directory.
  set_dictionary_path DICTIONARY_PATH
end
