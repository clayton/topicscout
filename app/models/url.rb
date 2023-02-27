class Url < ApplicationRecord
  belongs_to :tweet

  scope :relevant, -> { where(tweets: { saved: false, ignored: false, archived: false }) }
  scope :titled, -> { where.not(urls: { title: nil }) }
  scope :qualified, ->(threshold) { where(Tweet.arel_table[:score].gteq(threshold)) }

  def hostname
    return unless unwound_url

    URI.parse(unwound_url).host
  end
end
