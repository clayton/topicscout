require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'creating a search phrase' do
    subject { described_class.create!(topic: 'widgets') }

    it 'uses keywords from search terms' do
      subject.search_terms.create(term: 'foo')
      subject.search_terms.create(term: 'bar')

      expect(subject.search_phrase).to eq('"widgets" OR "foo" OR "bar"')
    end
  end
end
