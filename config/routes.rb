Rails.application.routes.draw do

  mount Resque::Server, at: '/resque'

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', :registrations => 'users/registrations'}
  root :to => "landing#start"

  resources :users do 
    delete :unlink_provider
  end

  resources :noticias
end
