class CreateTweeterIgnoreRules < ActiveRecord::Migration[7.0]
  def change
    create_table :tweeter_ignore_rules, id: :uuid do |t|
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :author_id

      t.timestamps
    end
  end
end
