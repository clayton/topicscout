namespace :tokens do
  desc 'Refresh twitter auth tokens'
  task refresh: :environment do
    TwitterAccount.expiring.each do |account|
      account.refresh_auth_token!
    end
  end
end
