# encoding: utf-8
require 'helper'

describe 'OTS::Article' do
  before do
    @sample = <<-TEXT
      The hawksbill turtle is a critically endangered sea turtle belonging to the family Cheloniidae.
      It is the only species in its genus. The species has a worldwide distribution, with Atlantic and
      Pacific subspecies.
    TEXT

    @article = OTS::Article.new(@sample)
  end

  it 'should extract topic keywords from given document' do
    assert_equal %w(species turtle subspecies pacific atlantic), @article.topics
  end

  it 'should extract keywords from given document' do
    expect = %w{
      species turtle subspecies pacific atlantic distribution worldwide genus cheloniidae family
      belonging sea endangered critically hawksbill
    }

    assert_equal expect, @article.keywords
  end


  it 'should summarize sentences from given document' do
    lines  = @article.summarize(sentences: 2).map {|line| [line[:sentence].gsub(/\s+/, ' ').strip, line[:score]]}
    expect = [
      ["The hawksbill turtle is a critically endangered sea turtle belonging to the family Cheloniidae.", 48],
      ["The species has a worldwide distribution, with Atlantic and Pacific subspecies.", 20],
    ]

    assert_equal expect, lines
  end

  it 'should utf8 encode strings properly' do
    text    = "The hawksbill turtle\xE2\x80\x93is critically endangered.".force_encoding('utf-8')
    article = OTS.parse(text)
    summary = article.summarize(sentences: 1).first[:sentence]
    assert_equal text, summary
  end

  describe 'dictionaries' do
    before do
      @text = "j'ai besoin de la crème glacée. il fait trop chaud en australie."
    end

    it 'should load the french dictionary' do
      article = OTS.parse(@text, language: "fr")
      assert_equal "j'ai besoin de la crème glacée.", article.summarize(sentences: 1).first[:sentence]
    end

    it 'should load the french dictionary given path' do
      article = OTS.parse(@text, dictionary: File.join(File.dirname(__FILE__), '..', 'dictionaries', 'fr.xml'))
      assert_equal "j'ai besoin de la crème glacée.", article.summarize(sentences: 1).first[:sentence]
    end

    it 'should raise LoadError on invalid language or dictionaries' do
      assert_raises(LoadError) do
        OTS.parse('hello world', language: "xxx")
      end

      assert_raises(LoadError) do
        OTS.parse('hello world', dictionary: "xxx")
      end

      assert_raises(LoadError) do
        OTS.parse('hello world', dictionary: __FILE__)
      end
    end
  end
end
