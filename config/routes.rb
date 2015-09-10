Rails.application.routes.draw do

  mount Resque::Server, at: '/resque'

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations'}
  mount Mercury::Engine => '/'
  root :to => "landing#start"

  devise_scope :user do
    delete 'unlink_provider' => "users/registrations#unlink_provider"
  end

  resources :notice_groups, path: '/noticias', only: [:index, :show]
  resources :static_pages, only: [:show, :update, :index]
  resources :notices, only: [:destroy] do
    member do
      post "unlink"
    end
  end
  resources :comments, only: [:destroy]
  resources :users, only: [:index, :destroy]
end
