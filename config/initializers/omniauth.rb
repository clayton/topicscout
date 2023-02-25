# require 'omniauth/strategies/twitter2'

Rails.application.config.middleware.use OmniAuth::Builder do
  # configure do |config|
  #   config.path_prefix = "/"
  # end

  # binding.irb
  provider :twitter2, Rails.application.credentials.twitter.client_id, 
           Rails.application.credentials.twitter.client_secret,
           callback_path: '/auth/twitter2/callback',
           scope: 'tweet.read users.read follows.write list.read list.write offline.access'
end

OmniAuth.config.allowed_request_methods = %i[post get] if Rails.env.development?
