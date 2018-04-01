Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/welcome', to: 'welcome#index'


  root   'home#index'
  get    'auth'            => 'home#auth'
  
  # Get login token from Knock
  post   'user_token'      => 'user_token#create'
  
  # User actions
  get    '/users'          => 'users#index'
  get    '/users/current'  => 'users#current'
  post   '/users/create'   => 'users#create'
  patch  '/user/:id'       => 'users#update'
  delete '/user/:id'       => 'users#destroy'

  get '/users/balance', to: 'users#balance'
  post '/users/transfer', to: 'users#transfer'
  # post '/users/withdraw', to: 'users#withdraw'
  get '/users/deposit', to: 'users#deposit'
end
