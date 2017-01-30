Rails.application.routes.draw do
  get 'recorders/new'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/setup', to: 'recorders#new'
  post '/setup', to: 'recorders#create'

  resources :recorders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
