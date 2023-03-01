class AddDeletedToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :deleted, :boolean, default: false
  end
end
