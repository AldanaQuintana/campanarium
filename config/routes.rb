Rails.application.routes.draw do

  JSON_MIME_TYPE = "application/json"

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

  post "response_from_analyzer", to: "semantic_analyzer#response_from_analyzer"
  post "response_from_sentiments_analyzer", to: "sentiments_analyzer#response_from_analyzer"

  get "admin_board", to: "admin#board"
  post "sentiments_analyzer", to: "sentiments_analyzer#call_analyzer"
  post "semantic_analyzer", to: "semantic_analyzer#call_analyzer"
  post "load_comments", to: "admin#load_comments"
  post "load_notices", to: "admin#load_notices"
  get "async_response", to: "admin#async_response"
end
