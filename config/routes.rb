Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :recipes
  resources :foods,only:[:index,:new,:create,:destroy]
  get 'public_recipes', to: 'recipes#public_recipes'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "recipes#index"
end
