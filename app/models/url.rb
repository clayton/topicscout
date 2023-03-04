class Url < ApplicationRecord
  belongs_to :tweet

  scope :unique, -> { distinct('unwound_url') }
  scope :unedited, -> { where(tweets: { saved: false, archived: false }) }
  scope :uncollected, -> { where(tweets: { collection_id: nil }) }
  scope :relevant, -> { where(tweets: { ignored: false }) }
  scope :qualified, ->(threshold) { where(Tweet.arel_table[:score].gteq(threshold)) }

  before_create :cleanup_unwound_url
  before_create :calculate_uri_hash

  def hostname
    return unless unwound_url

    begin
      URI.parse(unwound_url).host
    rescue StandardError
      unwound_url.truncate(20)
    end
  end

  def populate_editorial_fields!
    update!(editorial_title: title, editorial_url: strip_utm(unwound_url))
  end

  def tweet_score
    tweet.score
  end

  private

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

  def calculate_uri_hash
    return unless unwound_url
    return if uri_hash.present?

    self.uri_hash = Digest::SHA2.hexdigest(unwound_url)
  end
end
