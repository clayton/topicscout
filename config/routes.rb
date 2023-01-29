Rails.application.routes.draw do
  namespace :onboarding do
    get 'email_verifications/edit'
    resources :topics
    resources :users
    resources :email_verifications
    resources :twitter_accounts
  end

  get '/onboarding/start', to: 'onboarding/twitter_accounts#new', as: :onboarding_start
  get '/onboarding/topics/new', to: 'onboarding/topics#new', as: :onboarding_first_topic
  get '/onboarding/topics/:topic_id/refine', to: 'onboarding/topics#edit', as: :onboarding_refine
  get '/onboarding/topics/:topic_id/finish', to: 'onboarding/users#edit', as: :onboarding_finish

  resources :topics do
    resources :twitter_search_results
    resources :search_terms
    resources :tweets
    resources :tweeter_ignore_rules
  end

  resources :users do
    resources :email_verifications
  end

  resources :twitter_accounts

  get '/dashboard', to: 'dashboard#show', as: :dashboard
  get '/profile', to: 'users#edit', as: :profile
  get '/login', to: 'email_authentications#new', as: 'login'
  post '/login', to: 'email_authentications#create', as: 'login_challenge'
  post '/login/verify', to: 'sessions#create', as: 'verify_login'
  get '/auth/:provider/callback', to: 'twitter_accounts#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/checkouts/:checkout_session_id', to: 'checkouts#show'

  root 'dashboard#show'
end
