class AddPausedToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :paused, :boolean
  end
end
