class Influencer < ApplicationRecord
  belongs_to :topic

  has_many :tweets
  has_many :influenced_urls
  has_many :urls, through: :influenced_urls
end