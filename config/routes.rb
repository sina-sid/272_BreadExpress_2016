BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items 
  resources :sessions
  resources :users
  resources :item_prices
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
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  get 'cart' => 'orders#view_cart', as: :cart
  get 'add-to-cart/:id' => 'orders#add_to_cart', as: :add_to_cart
  get 'remove-from-cart/:id' => 'orders#remove_from_cart', as: :remove_from_cart
  get 'checkout' => 'orders#new', as: :checkout



  # patch 'shipped/:id' => 'order_items#mark_shipped', as: :shipped
  # patch 'unshipped/:id' => 'order_items#mark_unshipped', as: :unshipped
  patch 'mark_shipped_path/:id' => 'order_items#mark_shipped', as: :mark_shipped
  patch 'mark_unshipped_path/:id' => 'order_items#mark_unshipped', as: :mark_unshipped
  # get 'new/:id' => 'item_prices#new', as: :new_item_price
  
  

  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
