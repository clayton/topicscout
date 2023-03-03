class RemoveEditorialCategoryNameFromTweets < ActiveRecord::Migration[7.0]
  def change
    remove_column :tweets, :editorial_category, :string
  end
end
