class CreateCategoryTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :category_templates, id: :uuid do |t|
      t.string :name
      t.references :topic, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
