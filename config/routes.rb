Rails.application.routes.draw do
  resources :bulk_insert_lists
  root 'books#index'
  get 'main/search'
  get 'main/autocomplete'
  resources :books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :search, controller: :main
  get :autocomplete, controller: :main
  delete :delete_image_attachment, controller: :books
end
