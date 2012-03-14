Kulaverse::Application.routes.draw do
  resources :levels

  root :to => "levels#index"

end
