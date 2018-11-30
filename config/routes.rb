Rails.application.routes.draw do

  resources :users, only: [:show, :create, :update]

  resources :user_tokens, only: [:create]
  
end
