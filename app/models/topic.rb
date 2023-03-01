class Topic < ApplicationRecord
  has_many :tweeter_ignore_rules, dependent: :destroy
  has_many :hostname_ignore_rules, dependent: :destroy
  has_many :twitter_search_results, dependent: :destroy
  has_many :tweets, dependent: :destroy
  has_many :search_terms, dependent: :destroy
  has_many :negative_search_terms, dependent: :destroy
  has_many :urls
  has_many :collections, dependent: :destroy
  has_many :twitter_lists, dependent: :destroy

  belongs_to :user

  after_create :create_search_term
  after_create_commit :initial_search
  after_create_commit :create_list_on_twitter

  accepts_nested_attributes_for :search_terms, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :negative_search_terms, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :twitter_lists, allow_destroy: true, reject_if: :all_blank

  def user_auth_token
    user.auth_token
  end

  def latest_results_count
    twitter_search_results.completed.newest.first&.results_count || 0
  end

  def unedited_tweets(sort = 'score', time_filter = 'all')
    results = tweets.includes(:hashtags).relevant.unedited.qualified(threshold)
    filtered_and_sorted_results(results, sort, time_filter)
  end

  def unedited_urls(sort = 'score', time_filter = 'all')
    results = urls.includes(:tweet).relevant.unedited.qualified(threshold)
    filtered_and_sorted_results(results, sort, time_filter)
  end

  def filtered_and_sorted_results(results, sort = 'score', time_filter = 'all')
    results = filtered_results(results, time_filter)
    sorted_results(results, sort)
  end

  def filtered_results(results, time_filter = 'all')
    results = results.where('tweets.tweeted_at > ?', 1.hour.ago) if time_filter == 'hour'
    results = results.where('tweets.tweeted_at > ?', 1.day.ago) if time_filter == 'day'
    results = results.where('tweets.tweeted_at > ?', 1.week.ago) if time_filter == 'week'

    results
  end

  def sorted_results(results, sort = 'score')
    results = results.order(Tweet.arel_table[:tweeted_at].desc) if sort == 'newest'
    results = results.order(Tweet.arel_table[:score].desc) if sort == 'score' || sort.nil?

    results
  end

  def saved_tweets(sort = 'score', time_filter = 'all')
    results = tweets.includes(:hashtags, :urls).reviewing.uncollected
    results = results.where('tweets.tweeted_at > ?', 1.hour.ago) if time_filter == 'hour'
    results = results.where('tweets.tweeted_at > ?', 1.day.ago) if time_filter == 'day'
    results = results.where('tweets.tweeted_at > ?', 1.week.ago) if time_filter == 'week'
    results = results.order(Tweet.arel_table[:tweeted_at].desc) if sort == 'newest'
    results = results.order(Tweet.arel_table[:score].desc) if sort == 'score' || sort.nil?

    results
  end

  def search_in_progress?
    twitter_search_results.incomplete.any?
  end

  def latest_result
    twitter_search_results.completed.order(created_at: :desc).first
  end

  def new_search_terms=(search_terms)
    search_terms.each do |search_term|
      next if search_term['term'].nil?
      next if search_term['term'].strip.blank?

      search_terms << SearchTerm.new(search_term)
    end
  end

  def search_terms_attributes=(attributes)
    attributes.each do |_key, term|
      if term['id'].nil?
        next if term[:term].strip.blank?

        persisted? ? search_terms.create!(term) : search_terms.build(term)
      else
        search_term = search_terms.find_by(id: term['id'])
        if term[:term].blank?
          search_term.destroy
        else
          search_term.update(term: term[:term], required: term[:required], exact_match: term[:exact_match])
        end
      end
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
      next if term[:term].nil?

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

  def to_query
    search_phrase
  end

  def search_phrase
    required_keywords = assemble_required_keywords
    optional_keywords = assemble_optional_keywords
    negative_keywords = assemble_negative_keywords
    language_filters  = assemble_language_filters
    attribute_filters = assemble_attribute_filters

    [required_keywords,
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

    keywords = (optional_exact_keywords + optional_inexact_keywords).flatten.join(' OR ')

    "(#{keywords})"
  end

  def assemble_language_filters
    "lang:#{filter_by_language}" if filter_by_language.present?
  end

  def assemble_attribute_filters
    filters = []
    filters << '-is:retweet'
    filters << 'has:images' if require_images
    filters << 'has:media' if require_media
    filters << 'has:links' if require_links
    filters << 'is:verified' if require_verified

    # This next one doesn't work as expected and results in no tweets being found
    # filters << '-is:nullcast' if ignore_ads

    filters.join(' ')
  end

  def assemble_negative_keywords
    return if negative_search_terms.empty?

    negative_search_terms.map(&:to_query).flatten.uniq.join(' ')
  end

  def create_search_term
    search_terms.create(term: topic, required: true, exact_match: true)
  end

  def initial_search
    twitter_search_results.create(
      max_results: 12,
      limited: true,
      start_time: DateTime.yesterday.beginning_of_day
    )
  end

  def create_list_on_twitter
    named = "TS #{name}".truncate(25, omission: '')
    description = "A list of tweets about #{name} curated by Topic Scout."
    token = user_auth_token

    CreateTwitterListJob.perform_later(named, description, token, id)
  end
end
