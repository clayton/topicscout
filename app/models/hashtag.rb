class Hashtag < ApplicationRecord
  has_many :hashtag_entities
  has_many :tweets, through: :hashtag_entities
end
