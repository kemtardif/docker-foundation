Rails.application.routes.draw do
  resources :places

  resources :interventions, only: [ :new, :create]

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

 
  post "/interventions/new"         => "interventions#create"
  get '/search'               => "interventions#search"




  post '/leads'       => 'leads#create'
  post "/quotes"      => "quotes#create"

  match '/watson'     => 'watson#speak', via: :get
  match '/watson/st'  => 'watson#starwars', via: :post
 
   
  devise_scope :user do 
    get '/login' => 'devise/sessions#new' 
  end   

  

end
