Rails.application.routes.draw do

  resources :users, only: [:show, :create, :update]

  resources :user_tokens, only: [:create]

  resources :questions, only: [:index, :create] do
    resources :answers, only: [:index, :create]
  end

  get 'authentication_testing/authenticate', to:'authentication_testing#authenticate'
  
end
