Rails.application.routes.draw do

  resource :user, only: [:show, :update, :destroy]
  resources :users, only: [:index, :show, :create]

  resources :user_tokens, only: [:create]
  resource :user_token, only: [:destroy]

  resources :questions, only: [:index, :show, :create, :update, :destroy] do
    resources :answers, only: [:index, :create]
    resource :like, only: [:create, :destroy]
  end

  resources :answers, only: [:show, :update, :destroy] do
    resource :like, only: [:create, :destroy]
  end

  get 'authentication_testing/authenticate', to:'authentication_testing#authenticate'
  
end
