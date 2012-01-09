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

  it 'should extract title keywords from given document' do
    assert_equal 'species,turtle,subspecies,pacific,atlantic', @article.title
  end

  it 'should extract keywords from given document' do
    expect = %w{
      species turtle subspecies pacific atlantic distribution worldwide genus cheloniidae family
      belonging sea endangered critically hawksbill
    }

    assert_equal expect, @article.keywords
  end


  it 'should extract keywords from given document' do
    lines  = @article.summarize(lines: 2).map {|line| [line[:sentence].gsub(/\s+/, ' ').strip, line[:score]]}
    expect = [
      ["The hawksbill turtle is a critically endangered sea turtle belonging to the family Cheloniidae.", 48],
      ["The species has a worldwide distribution, with Atlantic and Pacific subspecies.", 20],
    ]

    assert_equal expect, lines
  end

  it 'should utf8 encode strings properly' do
    text    = "The hawksbill turtle\xE2\x80\x93is critically endangered.".force_encoding('utf-8')
    article = OTS.parse(text)
    summary = article.summarize(lines: 1).first[:sentence]
    assert_equal text, summary
  end

  describe 'dictionaries' do
    it 'should load the french dictionary' do
      article = OTS.parse("j'ai besoin de la crème glacée. il fait trop chaud en australie.", "fr")
      assert_equal "j'ai besoin de la crème glacée.", article.summarize(lines: 1).first[:sentence]
    end
  end
end
