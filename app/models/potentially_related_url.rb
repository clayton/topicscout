class PotentiallyRelatedUrl < ApplicationRecord
  belongs_to :topic
  belongs_to :original_url, class_name: 'Url', foreign_key: 'url_id'
  belongs_to :related_url, class_name: 'Url', foreign_key: 'related_url_id'
end
