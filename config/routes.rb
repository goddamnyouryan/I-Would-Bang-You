Bang::Application.routes.draw do

  devise_for :users
  root :to => "users#index"
  resources :ratings, :only => ["create", "destroy"]
  resources :photos, :only => ["index", "create"]
  resources :users, :only => ["show", "index"] do
    resources :photos do
      match "make_profile", :to => 'photos#make_profile'
    end
    resources :ratings
  end
  resources :messages do
    resources :responses
  end
  
end
