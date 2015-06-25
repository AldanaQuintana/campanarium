Rails.application.routes.draw do

  mount Mercury::Engine => '/'
  root :to => "landing#start"

  resources :static_pages, only: [:show, :update]
end
