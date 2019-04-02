Rails.application.routes.draw do
  root 'books#index'
  get 'main/search'
  get 'main/autocomplete'
  resources :books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :search, controller: :main
  get :autocomplete, controller: :main
end
