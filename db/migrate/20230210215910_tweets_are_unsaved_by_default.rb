class TweetsAreUnsavedByDefault < ActiveRecord::Migration[7.0]
  def change
    Tweet.where(saved: nil).update_all(saved: false)

    change_column_null :tweets, :saved, false
  end
end
