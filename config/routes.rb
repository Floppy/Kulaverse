Kulaverse::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :controllers => { 
                                        :omniauth_callbacks => "users/omniauth_callbacks",
                                        :sessions => "users/sessions",
                                     } do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  resources :worlds do
    resources :levels do
      resources :scores
    end
  end
  
  root :to => "levels#index", :world_id => 1, :id => 1

  get "help/about"

end
