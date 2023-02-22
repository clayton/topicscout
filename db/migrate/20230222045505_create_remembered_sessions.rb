class CreateRememberedSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :remembered_sessions, id: :uuid do |t|
      t.uuid :user_id
      t.datetime :expires_at, precision: nil, null: false
      t.string :lookup, null: false
      t.string :validator, null: false

      t.timestamps
    end
  end
end
