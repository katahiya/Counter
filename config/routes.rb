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
    resources :recorders, except: [:new, :create], shallow: true do
      resources :options, except: [:show, :new, :create], shallow: true do
        resources :records, only: [:create, :destroy]
      end
    end
  end
  get 'recorders/:id/add_options', to: 'recorders#add_options', as: :recorder_add_options
  patch 'recorders/:id/add_options', to: 'recorders#update_options'
  get 'recorders/:id/edit_title', to: 'recorders#edit_title', as: :recorder_edit_title
  patch 'recorders/:id/edit_title', to: 'recorders#update_title'
  get 'recorders/:id/delete', to: 'recorders#delete', as: :delete_recorder
  get 'options/:id/delete', to: 'options#delete', as: :delete_option
  get 'records/:id/delete', to: 'records#delete', as: :delete_record
  get '/plural_delete_records', to: 'plural_actions#delete_records', as: :plural_delete_records
  delete '/plural_delete_records', to: 'plural_actions#destroy_records'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
