Rails.application.routes.draw do
  get 'main/search'
  resources :books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :search, controller: :main
end
