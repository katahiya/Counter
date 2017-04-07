Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, shallow: true do
    get '/setup', to: 'recorders#new'
    post '/setup', to: 'recorders#create'
    resources :recorders, except: [:new, :create], shallow: true do
      resources :options, except: [:show, :new, :create], shallow: true do
        resources :records, only: [:create, :destroy]
      end
      resources :recordabilities, except: [:index, :show]
    end
  end
  get 'recorders/:id/add_options', to: 'recorders#add_options', as: :recorder_add_options
  patch 'recorders/:id/add_options', to: 'recorders#update_options'
  get 'recorders/:id/edit_title', to: 'recorders#edit_title', as: :recorder_edit_title
  patch 'recorders/:id/edit_title', to: 'recorders#update_title'
  get 'recorders/:id/delete', to: 'recorders#delete', as: :delete_recorder
  get 'recorders/:id/graph', to: 'graph#show', as: :graph
  post 'options/:id/register', to: 'single_register#create', as: :single_register
  get 'options/:id/delete', to: 'options#delete', as: :delete_option
  get 'recordabilities/:id/duplicate', to: 'recordabilities#duplicate', as: :duplicate_recordability
  get 'recordabilities/:id/delete', to: 'recordabilities#delete', as: :delete_recordability
  get '/delete_recordablities', to: 'plural_actions#delete_recordabilities', as: :delete_recordabilities
  delete '/delete_recordablities', to: 'plural_actions#destroy_recordabilities'
  get '/delete_options', to: 'plural_actions#delete_options', as: :delete_options
  delete '/delete_options', to: 'plural_actions#destroy_options'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
