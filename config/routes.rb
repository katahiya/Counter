Rails.application.routes.draw do

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, shallow: true do
    get '/setup', to: 'recorders#new'
    post '/setup', to: 'recorders#create'
    resources :recorders, except: [:new, :create], path_names: {edit: "edit_title"}, shallow: true do
      resources :options, except: [:show, :new, :create], shallow: true do
        resources :records, only: [:create, :destroy]
      end
    end
  end
  get 'recorders/:id/add_options', to: 'recorders#add_options', as: :recorder_add_options
  patch 'recorders/:id/add_options', to: 'recorders#update_options'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
