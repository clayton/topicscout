Rails.application.routes.draw do
  namespace :onboarding do
    get 'email_verifications/edit'
    resources :topics
    resources :users
    resources :email_verifications
  end

  get '/onboarding/start', to: 'onboarding/topics#new', as: :onboarding_start
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

  get '/dashboard', to: 'dashboard#show', as: :dashboard
  get '/profile', to: 'users#edit', as: :profile
  get '/login', to: 'sessions#new', as: 'login'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  root 'dashboard#show'
end
