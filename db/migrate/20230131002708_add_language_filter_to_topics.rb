class AddLanguageFilterToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :filter_by_language, :string
  end
end
