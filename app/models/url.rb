class Url < ApplicationRecord
  belongs_to :topic
  belongs_to :collection, optional: true

  has_many :tweeted_urls
  has_many :tweets, through: :tweeted_urls

  has_many :influenced_urls
  has_many :influencers, through: :influenced_urls

  after_save_commit :promote_to_list
  after_save :populate_editorial_fields!

  scope :unedited, -> { where(saved: false, archived: false) }
  scope :newest, -> { order(published_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(40) }
  scope :ignored, -> { where(ignored: true) }
  scope :relevant, -> { where(ignored: false) }
  scope :qualified, ->(threshold) { where(['score >= ?', threshold]) }
  scope :best, -> { order(score: :desc) }
  scope :reviewing, -> { where(ignored: false, saved: true, archived: false, collection_id: nil) }
  scope :uncollected, -> { where(collection_id: nil) }
  scope :collected, -> { where.not(collection_id: nil) }
  scope :unsaved, -> { where(saved: false) }

  before_create :cleanup_unwound_url

  def hostname
    return unless unwound_url

    begin
      URI.parse(unwound_url).host
    rescue StandardError
      unwound_url.truncate(20)
    end
  end

  def first_influencer
    influencers.first
  end

  def first_influencer_username
    first_influencer&.username
  end

  def first_influencer_profile_url
    first_influencer&.profile_url
  end

  private

  def populate_editorial_fields!
    return unless saved? && saved_change_to_collection_id?

    update!(editorial_title: title, editorial_url: strip_utm(unwound_url))
  end

  def strip_utm(url)
    return unless url

    begin
      uri = URI.parse(url)
      clean_key_vals = URI.decode_www_form(uri.query).reject { |k, _| k.start_with?('utm_') }
      uri.query = URI.encode_www_form(clean_key_vals)

      uri.to_s
    rescue StandardError
      url
    end
  end

  def cleanup_unwound_url
    return unless unwound_url

    self.unwound_url = strip_utm(unwound_url)
  end

  def promote_to_list
    return unless saved? && saved_change_to_collection_id?

    list_id = topic.twitter_lists.managed.first&.twitter_list_id

    return if list_id.blank?

    first_influencer = influenced_urls.order(created_at: :asc).first&.influencer

    return unless first_influencer

    PromoteUserToListJob.perform_later(
      topic.user_auth_token,
      list_id,
      first_influencer.platform_id
    )
  end
end
