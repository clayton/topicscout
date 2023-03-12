class TwitterListMembership < ApplicationRecord
  belongs_to :twitter_list

  def self.add_to_twitter_list(list_id, user_id)
    list = TwitterList.find_by(twitter_list_id: list_id, managed: true)
    return if list.blank?

    find_or_create_by(twitter_list_id: list.id, author_id: user_id)
  end
end
