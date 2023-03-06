class AddCleanUrlToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :clean_url, :string
    add_index :urls, :unwound_url
  end
end
