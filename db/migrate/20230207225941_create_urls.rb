class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls, id: :uuid do |t|
      t.string :display_url
      t.string :title
      t.string :status
      t.string :unwound_url
      t.string :url

      t.timestamps
    end
  end
end
