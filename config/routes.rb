Bang::Application.routes.draw do

  match "/users/check_login" => "users#check_login"
  devise_for :users, :controllers => { :registrations => "users/registrations", :sessions => "users/sessions" }
  root :to => "users#index"
  resources :photos, :only => ["index", "create"]
  resources :users, :only => ["show", "index"] do
    resources :photos do
      match "/users/:login" => 'users#show', :as => :login
      match "make_profile", :to => 'photos#make_profile'
      match "edit_caption", :to => 'photos#edit_caption'
      match "update_caption", :to => 'photos#update_caption'
      post :sort, on = :collection
    end
    resources :ratings  
    resources :questions, :only => ["edit", "update"]
    match "hide", :to => 'hides#create'
    match "unhide", :to => 'hides#destroy'
    match "sort", :to => 'photos#sort'
    match "rate", :to => 'ratings#browse_rate'
    match "answer_questions", :to => 'users#answer_questions'
    match "questions", :to => 'users#questions'
    match "about", :to => 'users#about'
  end
  match '/search', :to =>'users#search'
  match '/random', :to => 'users#random'
  match '/history', :to => 'users#history'
  match '/about', :to => 'users#learn_more'
  match '/contact', :to => 'users#contact'
  resources :messages do
    resources :responses
  end
  resources :questions, :only => [ :edit, :update ]
  
end
