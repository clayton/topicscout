class CreateTwitterAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :twitter_accounts, id: :uuid do |t|
      t.uuid :user_id
      t.string :provider
      t.string :uid
      t.string :name
      t.string :image
      t.string :username

      t.timestamps
    end
  end
end
