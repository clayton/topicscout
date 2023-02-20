class AddAllTopicKeywordsToSearchTerms < ActiveRecord::Migration[7.0]
  def change
    Topic.all.each do |topic|
      term = topic.search_terms.find_or_create_by(term: topic.topic)
      term.update(required: false, exact_match: true)
    end
  end
end
