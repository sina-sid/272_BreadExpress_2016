BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items 
  resources :sessions
  # resources :cart do
  #   get 'add_to_cart' => 'cart#show', as: :add_to_cart, on: :collection
  # end
  # resources :users
  # resources :order_items
  # resources :item_prices

  
  # Authentication routes
  get 'user/edit' => 'users#edit', as: :edit_current_user
  get 'signup' => 'users#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  get 'cart' => 'cart#show', as: :cart
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  
  

  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
