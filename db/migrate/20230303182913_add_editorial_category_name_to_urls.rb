class AddEditorialCategoryNameToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :editorial_category, :string
  end
end
