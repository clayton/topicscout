class Topic < ApplicationRecord
  has_many :tweeter_ignore_rules, dependent: :destroy
  has_many :twitter_search_results, dependent: :destroy
  has_many :tweets, dependent: :destroy
  has_many :search_terms, dependent: :destroy
  has_many :negative_search_terms, dependent: :destroy
  has_many :urls, through: :tweets
  has_many :collections, dependent: :destroy

  belongs_to :user

  validates :topic, presence: true

  before_create :sanitize_topic
  before_save :calculate_search_hour
  after_create :initial_search

  accepts_nested_attributes_for :search_terms, allow_destroy: true
  accepts_nested_attributes_for :negative_search_terms, allow_destroy: true

  def unedited_tweets
    tweets.qualified(threshold).relevant.unedited.best
  end

  def unedited_urls
    urls.includes(:tweet)
        .where(tweets: { saved: false, ignored: false, archived: false })
        .where.not(urls: { title: nil })
        .where(Tweet.arel_table[:score].gteq(threshold))
        .order(Tweet.arel_table[:score].desc)
  end

  def latest_result
    twitter_search_results.completed.order(created_at: :desc).first
  end

  def new_search_terms=(terms)
    terms.each do |term|
      next if term.strip.blank?

      search_terms << SearchTerm.new(term: term)
    end
  end

  def search_terms_attributes=(attributes)
    attributes.each do |_key, term|
      search_term = search_terms.find_by(id: term['id'])
      if term[:term].strip.blank?
        search_term.destroy
        next
      end
      search_term.update(term: term[:term], required: term[:required], exact_match: term[:exact_match])
    end
  end

  def search_term=(attributes)
    term = attributes[:term]

    return if term.nil?
    return if term.empty?
    return if term.downcase.strip.empty?

    search_terms.find_or_create_by(term: term, required: attributes[:required], exact_match: attributes[:exact_match])
  end

  def new_negative_search_terms=(terms)
    terms.each do |term|
      next if term.strip.blank?

      negative_search_terms << NegativeSearchTerm.new(term: term)
    end
  end

  def negative_search_terms_attributes=(attributes)
    attributes.each do |_key, term|
      negative_search_term = negative_search_terms.find_by(id: term['id'])
      if term[:term].strip.blank?
        negative_search_term.destroy
        next
      end
      negative_search_term.update(term: term[:term])
    end
  end

  def negative_search_term=(attributes)
    term = attributes[:term]

    return if term.nil?
    return if term.empty?
    return if term.downcase.strip.empty?

    negative_search_terms.find_or_create_by(term: term)
  end

  def search_phrase
    required_keywords = assemble_required_keywords
    optional_keywords = assemble_optional_keywords
    negative_keywords = assemble_negative_keywords
    language_filters  = assemble_language_filters
    attribute_filters = assemble_attribute_filters

    keyword = topic.starts_with?('#') ? topic : %("#{topic}")

    [keyword,
     required_keywords,
     optional_keywords,
     negative_keywords,
     language_filters,
     attribute_filters].compact.join(' ')
  end

  def assemble_required_keywords
    return if search_terms.where(required: true).empty?

    required_exact_keywords = search_terms.required.exact.map(&:to_query)
    required_inexact_keywords = search_terms.required.fuzzy.map(&:to_query)

    (required_exact_keywords + required_inexact_keywords).flatten.join(' ')
  end

  def assemble_optional_keywords
    return if search_terms.where(required: false).empty?

    optional_exact_keywords = search_terms.optional.exact.map(&:to_query)
    optional_inexact_keywords = search_terms.optional.fuzzy.map(&:to_query)

    (optional_exact_keywords + optional_inexact_keywords).flatten.join(' OR ')
  end

  def assemble_language_filters
    "lang:#{filter_by_language}" if filter_by_language.present?
  end

  def assemble_attribute_filters
    filters = []
    filters << 'has:images' if require_images
    filters << 'has:media' if require_media
    filters << 'has:links' if require_links
    filters << 'is:verified' if require_verified
    filters << '-is:nullcast' if ignore_ads

    filters.join(' ')
  end

  def assemble_negative_keywords
    return if negative_search_terms.empty?

    negative_search_terms.map { |search_term| %(-"#{search_term.term}") }.flatten.uniq.join(' ')
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

  def calculate_search_hour
    self.utc_search_hour = 14

    return if search_time_hour.blank?
    return if search_time_zone.blank?

    begin
      today = Time.parse("#{Date.today} #{search_time_hour}:00")
      in_specific_time_zone = today.in_time_zone(search_time_zone)
      self.utc_search_hour = in_specific_time_zone.in_time_zone('UTC').hour
    rescue StandardError => e
      self.utc_search_hour = 14
      Honeybadger.notify(e)
    end
  end
end
