class AddEditorialFieldsToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :editorial_title, :string
    add_column :urls, :editorial_url, :string
    add_column :urls, :editorial_description, :text
  end
end
