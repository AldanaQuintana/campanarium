Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', :registrations => 'users/registrations'}
  root :to => "landing#start"
  get 'signed_in', to: 'landing#temp'
end
