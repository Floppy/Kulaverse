Kulaverse::Application.routes.draw do
  devise_for :users, :controllers => { 
                                        :omniauth_callbacks => "users/omniauth_callbacks",
                                        :sessions => "users/sessions",
                                     } do
    get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  resources :levels

  root :to => "levels#index"

end
