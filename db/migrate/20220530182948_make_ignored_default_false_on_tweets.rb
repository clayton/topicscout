class MakeIgnoredDefaultFalseOnTweets < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tweets, :ignored, false
  end
end
