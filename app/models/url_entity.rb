class UrlEntity < ApplicationRecord
  belongs_to :topic
  belongs_to :tweet
  belongs_to :url
end
