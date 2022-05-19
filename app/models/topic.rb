class Topic < ApplicationRecord
  has_many :twitter_search_results
  has_many :tweets
  has_many :search_terms

  has_many :interests
  has_many :users, through: :interests
  has_many :tweet_read_receipts, through: :interests

  validates :topic, presence: true

  after_create :create_search_term
  after_create :initial_search

  def search_term_attributes=(attributes)
    attributes.each do |term|
      next if term.nil?
      next if term.empty?
      next if term.downcase.strip.empty?

      search_terms.find_or_create_by(term: term.downcase.strip)
    end
  end

  def search_phrase
    terms = search_terms.map { |search_term| %("#{search_term.term}") }

    terms.join(' OR ')
  end

  def initial_search
    twitter_search_results.create(
      max_results: 10, 
      start_time: DateTime.yesterday.beginning_of_day
    )
  end

  def create_search_term
    search_terms.create(term: topic.downcase.strip)
  end
end
