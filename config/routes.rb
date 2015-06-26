Rails.application.routes.draw do

  devise_for :users, path_names: {
    sign_in: ''
  }
  root :to => "landing#start"
  get 'signed_in', to: 'landing#temp'
end
