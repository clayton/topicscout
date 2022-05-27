require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'creating a search phrase' do
    let(:user) { User.create(email: 'user@example.com') }
    subject { described_class.create!(topic: 'widgets', user: user) }

    context 'when there are search terms' do
      it 'uses keywords from search terms' do
        subject.search_terms.create(term: 'foo')
        subject.search_terms.create(term: 'bar')
  
        expect(subject.search_phrase).to eq('"widgets" ("foo" OR "bar")')
      end
    end

    context 'when there are not search terms' do
      it 'just uses the topic' do  
        expect(subject.search_phrase).to eq('"widgets"')
      end      
    end
  end
end
