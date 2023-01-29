class CreateEmailAuthentications < ActiveRecord::Migration[7.0]
  def change
    create_table :email_authentications, id: :uuid do |t|
      t.integer :code
      t.datetime :expires_at
      t.uuid :user_id

      t.timestamps
    end
  end
end
