BreadExpress::Application.routes.draw do
  resources :customers
  resources :addresses
  resources :orders

  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  root :to => 'home#home'
end
