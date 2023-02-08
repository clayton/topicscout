class AddScoringToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :score, :decimal, default: 0
  end
end
