class CreateInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :interests, id: :uuid do |t|
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
