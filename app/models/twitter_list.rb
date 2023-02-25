class TwitterList < ApplicationRecord
  has_many :tweets
  belongs_to :topic
end
