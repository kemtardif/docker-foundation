Rails.application.routes.draw do
  resources :places
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root                to: 'pages#home'

  get '/corporate'    => 'pages#corporate'
  get '/home'         => 'pages#home'
  get '/error'        => 'pages#p404'
  get '/quote'        => 'pages#quote'
  get '/residential'  => 'pages#residential'
  get '/404'          => 'pages#p404'
  get '/charts'       => 'pages#charts'
  get '/diagram'      => 'pages#diagram'
  
  get '/googlemaps'   => 'places#googlemaps'

  post '/leads'       => 'leads#create'
  post '/quotes'      => 'quotes#create'
   
  devise_scope :user do 
    get '/login' => 'devise/sessions#new' 
  end   

  

end
