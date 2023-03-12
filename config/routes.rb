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
    resources :hostname_ignore_rules
    resources :twitter_search_results
    resources :search_terms
    resources :negative_search_terms
    resources :tweets do
      resources :twitter_list_memberships
      resources :search_terms, controller: 'tweet_search_terms'
      resources :negative_search_terms, controller: 'tweet_negative_search_terms'
    end
    resources :tweeter_ignore_rules
    resources :influencer_ignore_rules
    resources :urls do
      resources :similar_urls
    end
    resources :saves
    resources :archived_tweets
    resources :archived_urls
    resources :saved_tweets
    resources :saved_urls
  end

  resources :collections do
    resources :urls, controller: :collection_urls
    resources :tweets, controller: :collection_tweets
    resources :markdown_exports, as: :markdown
    resources :html_exports, as: :html
    resources :plain_text_exports, as: :plain_text
    resources :rendered_exports, as: :rendered
    resources :collected_tweets
    resources :collected_urls
  end

  resources :users do
    resources :email_verifications
  end

  resources :twitter_accounts

  namespace :admin do
    resources :users
    get '/logout', to: 'sessions#destroy', as: 'logout'
  end

  get '/dashboard', to: 'dashboard#show', as: :dashboard
  get '/profile', to: 'users#edit', as: :profile
  get '/login', to: 'email_authentications#new', as: 'login'
  post '/login', to: 'email_authentications#create', as: 'login_challenge'
  post '/login/verify', to: 'sessions#create', as: 'verify_login'
  get '/auth/:provider/callback', to: 'twitter_accounts#create'
  get '/auth/failure', to: 'twitter_accounts#destroy'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/checkouts/:checkout_session_id', to: 'checkouts#show'

  get '/up', to: 'health#show'

  root 'topics#index'
end
