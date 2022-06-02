class Topic < ApplicationRecord
  has_many :tweeter_ignore_rules, dependent: :destroy
  has_many :twitter_search_results, dependent: :destroy
  has_many :tweets, dependent: :destroy
  has_many :search_terms, dependent: :destroy

  belongs_to :user

  validates :topic, presence: true

  before_create :sanitize_topic
  after_create :initial_search

  accepts_nested_attributes_for :search_terms, allow_destroy: true

  def latest_result
    twitter_search_results.completed.order(created_at: :desc).first
  end

  def new_search_terms=(terms)
    terms.each do |term|
      next if term.strip.blank?

      search_terms << SearchTerm.new(term: term)
    end
  end

  def search_term_attributes=(attributes)
    attributes.each do |term|
      search_term = search_terms.find_by(id: term[:id])
      if term[:term].strip.blank?
        search_term.destroy
        next
      end
      search_term.update(term: term[:term])
    end
  end

  def search_term=(attributes)
    term = attributes[:term]

    return if term.nil?
    return if term.empty?
    return if term.downcase.strip.empty?

    search_terms.find_or_create_by(term: term)
  end

  def search_phrase
    optionals = search_terms.map { |search_term| %("#{search_term.term}") }.flatten.uniq.join(' OR ')

    hashtag_or_phrase = topic.starts_with?('#') ? topic : %("#{topic}")

    return %(#{hashtag_or_phrase} (#{optionals})) if optionals.present?

    hashtag_or_phrase
  end

  def initial_search
    twitter_search_results.create(
      max_results: 12,
      limited: true,
      start_time: DateTime.yesterday.beginning_of_day
    )
  end

  def sanitize_topic
    self.topic = topic.downcase.strip
  end
end
