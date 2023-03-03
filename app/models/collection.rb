class Collection < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :tweets
  has_many :collection_categories

  after_create_commit :create_categories

  scope :newest, -> { order(created_at: :desc).limit(1) }

  def create_categories
    topic.category_templates.order(:name).each do |category_template|
      collection_categories.create(
        name: category_template.name
      )
    end
  end
end
