Rails.application.routes.draw do

  root :to => "landing#start"

  resources :static_pages, only: [:show, :edit]
end
