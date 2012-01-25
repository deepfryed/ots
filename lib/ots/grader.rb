require 'nokogiri'

module OTS
  DICTIONARY_PATH = File.absolute_path(File.dirname(__FILE__) + '/../../dictionaries')
  class Grader
    def initialize options = {}
      path = options[:path] || File.join(DICTIONARY_PATH, options.fetch(:language, 'en').to_s + '.xml')
      @xml = Nokogiri::XML(File.read(path))
    end

    def stop_words
      @xml.xpath('//grader-tc/word').map {|word| word.text.downcase}
    end
  end
end
