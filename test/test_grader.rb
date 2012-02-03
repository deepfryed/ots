# encoding: utf-8
require 'helper'
require 'ots/grader'

describe 'OTS::Grader' do
  it 'should load the dictionary & return stop words' do
    assert OTS::Grader.new(language: 'en').stop_words
  end
end
