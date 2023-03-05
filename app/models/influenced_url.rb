class InfluencedUrl < ApplicationRecord
  belongs_to :influencer
  belongs_to :url
end
