Rails.application.routes.draw do

  resources :users, only: [:create, :update]

  resources :user_tokens, only: [:create]
  
end
