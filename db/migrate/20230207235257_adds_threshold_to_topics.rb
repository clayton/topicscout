class AddsThresholdToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :threshold, :decimal, default: 0.0
  end
end
