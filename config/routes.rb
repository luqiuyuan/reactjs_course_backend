Rails.application.routes.draw do

  resources :users, only: [:index, :show, :create, :update]

  resources :user_tokens, only: [:create]
  resource :user_token, only: [:destroy]

  resources :questions, only: [:index, :create] do
    resources :answers, only: [:index, :create]
    resource :like, only: [:create, :destroy]
  end

  get 'authentication_testing/authenticate', to:'authentication_testing#authenticate'
  
end
