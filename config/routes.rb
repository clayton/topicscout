Rails.application.routes.draw do
  get 'tweets/index'
  namespace :onboarding do
    resources :topics
    resources :interests
  end

  get '/onboarding/start', to: 'onboarding/topics#new', as: :onboarding_start
  get '/onboarding/topics/:topic_id/refine', to: 'onboarding/topics#edit', as: :onboarding_refine
  get '/onboarding/topics/:topic_id/finish', to: 'onboarding/interests#new', as: :onboarding_finish

  resources :topics do
    resources :twitter_search_results
    resources :search_terms
    resources :interests
    resources :tweets
    resources :tweet_read_receipts
  end

  get '/login', to: 'sessions#new', as: 'login'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  root 'topics#index'
end
