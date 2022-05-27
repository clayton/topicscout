# frozen_string_literal: true

require 'resque/server'
if Rails.env.development?
  Resque.redis = Redis.new(host: 'localhost', port: '6379')
else
  $redis = Redis.new(url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })

  Resque.redis = $redis
end
