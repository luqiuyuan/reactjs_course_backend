Rails.application.routes.draw do

  resources :users, only: [:create]

  resources :user_tokens, only: [:create]
  
end
