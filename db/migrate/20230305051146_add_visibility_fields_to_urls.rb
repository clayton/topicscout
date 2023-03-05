class AddVisibilityFieldsToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :ignored, :boolean, default: false
    add_column :urls, :archived, :boolean, default: false
    add_column :urls, :saved, :boolean, default: false
    add_column :urls, :collection_id, :uuid
  end
end
