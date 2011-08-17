Bang::Application.routes.draw do

  get "responses/create"

  get "responses/destroy"

  get "messages/index"

  get "messages/show"

  devise_for :users
  root :to => "users#index"
  resources :ratings, :only => ["create", "destroy"]
  resources :photos, :only => ["index", "create"]
  resources :users, :only => ["show", "index"] do
    resources :photos
    resources :ratings
  end
  resources :messages do
    resources :responses
  end
  
end
