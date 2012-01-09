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
end
