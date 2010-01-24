require 'helper'

class OTSTitleTest < Test::Unit::TestCase

  SAMPLE = <<-TEXT
    The hawksbill turtle is a critically endangered sea turtle belonging to the family Cheloniidae.
    It is the only species in its genus. The species has a worldwide distribution, with Atlantic and
    Pacific subspecies.
  TEXT

  context 'Title' do
    should 'extract title from given document' do
      ots = OTS.new
      ots.parse SAMPLE
      assert_equal ots.title, 'species,turtle,subspecies,pacific,atlantic'
    end
  end

  context 'Keywords' do
    should 'extract keywords from given document' do
      ots = OTS.new
      ots.parse SAMPLE
      assert_equal ots.keywords, %W(
        species turtle subspecies pacific atlantic distribution worldwide genus cheloniidae family
        belonging sea endangered critically hawksbill
      )
    end
  end

  context 'Summary' do
    should 'extract keywords from given document' do
      ots = OTS.new
      ots.parse SAMPLE
      lines = ots.summarize(:lines => 2).map do |value|
        { :sentence => value[:sentence].gsub(/\n\s*/, ' ').strip, :score => value[:score] }
      end

      assert_equal lines, [
        {
          :sentence => "The hawksbill turtle is a critically endangered sea turtle belonging to the family Cheloniidae.",
          :score    => 48
        },
        {
          :sentence => "The species has a worldwide distribution, with Atlantic and Pacific subspecies.",
          :score    => 20
        }
      ]
    end
  end

end
