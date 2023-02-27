class Url < ApplicationRecord
  belongs_to :tweet

  scope :unique, -> { distinct('unwound_url') }
  scope :unedited, -> { where(tweets: { saved: false, archived: false }) }
  scope :relevant, -> { where(tweets: { ignored: false }) }
  scope :qualified, ->(threshold) { where(Tweet.arel_table[:score].gteq(threshold)) }

  def hostname
    return unless unwound_url

    URI.parse(unwound_url).host
  end
end
