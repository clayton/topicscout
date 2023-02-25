class AddAuthTokenToTwitterAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_accounts, :auth_token, :string
  end
end
