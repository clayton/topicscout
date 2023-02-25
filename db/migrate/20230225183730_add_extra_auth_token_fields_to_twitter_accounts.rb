class AddExtraAuthTokenFieldsToTwitterAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_accounts, :refresh_token, :string
    add_column :twitter_accounts, :auth_token_expires_at, :datetime
  end
end
