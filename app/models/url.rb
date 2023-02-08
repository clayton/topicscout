class Url < ApplicationRecord
  has_many :url_entities
  has_many :tweets, through: :url_entities
end
