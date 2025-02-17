Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"
  post "/auth/:provider/callback", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
  get "/auth/failure", to: redirect("/")

  resource :dashboard, only: [ :show ]

  resources :games, only: [ :index, :new, :create ] do
    post :accept, on: :member
  end
end
