class AddSearchTimeToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :search_time_zone, :string, default: 'Pacific Time (US & Canada)'
    add_column :topics, :search_time_hour, :string, default: '8'
  end
end
