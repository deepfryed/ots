require 'helper'

describe 'OTS' do
  it 'parse() should return an article instance' do
    OTS.parse("hello world").must_be_kind_of OTS::Article
  end

  it 'parse() should raise ArgumentError on invalid text' do
    assert_raises(ArgumentError) do
      OTS.parse(1)
    end
  end

  it 'should return a list of dictonaries' do
    dictionaries = OTS.dictionaries

    %w(en fr it es de ru).each do |name|
      assert dictionaries.include?(name), "has #{name} dictionary"
    end

    assert_empty dictionaries.reject {|name| name.size == 2}, "dictionaries path should not have other junk"
  end
end
