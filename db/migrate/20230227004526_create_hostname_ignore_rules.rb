class CreateHostnameIgnoreRules < ActiveRecord::Migration[7.0]
  def change
    create_table :hostname_ignore_rules, id: :uuid do |t|
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :hostname

      t.timestamps
    end
  end
end
