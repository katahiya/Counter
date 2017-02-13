Rails.application.routes.draw do

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/setup', to: 'recorders#new'
  post '/setup', to: 'recorders#create'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  resources :users
  resources :recorders
  resources :records, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
