class AddLangToTweet < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :lang, :string
  end
end
