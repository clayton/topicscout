class AddEditorialCategoryNameToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :editorial_category, :string
  end
end
