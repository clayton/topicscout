class CreateEmailVerifications < ActiveRecord::Migration[7.0]
  def change
    create_table :email_verifications, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :code
      t.boolean :verified, default: false
      t.string :email

      t.timestamps
    end
  end
end
