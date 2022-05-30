class AddIgnoredToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :ignored, :boolean
    add_index :tweets, :ignored
  end
end
