class AddManagedListToTwitterLists < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_lists, :managed, :boolean
  end
end
