class AddUtcSearchTimeToTopics < ActiveRecord::Migration[7.0]
  def change
    change_column_default :topics, :search_time_zone, 'Pacific Time (US & Canada)'
    change_column_default :topics, :search_time_hour, '8'
    add_column :topics, :utc_search_hour, :integer, default: 14
    add_index :topics, :utc_search_hour
  end
end
