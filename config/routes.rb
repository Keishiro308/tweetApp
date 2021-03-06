Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root  'home#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/search', to: 'home#search'
  resources :users do
    member do
      get :following, :followers, :likes
    end
  end

  resources :acount_activations, only:[:edit]
  resources :password_rests, only:[:new,:create, :edit, :update]
  resources :posts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
