class AddScoreToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :score, :float, default: 0.0
  end
end
