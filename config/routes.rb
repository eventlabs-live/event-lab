Rails.application.routes.draw do
  # Devise routes
  devise_for :users

  # User routes
  resources :users, only: [:new, :index, :show, :edit, :update] do
    resources :ticket_types, except: [:show, :index]
  end

  # Check-in routes
  resources :check_ins, only: [:create]

  # Other resources
  resources :tickets, only: [:index, :show, :new, :create] do
    resources :registrations, only: [:new, :create, :index, :show] do
      resources :payments, only: [:new, :create, :show]
    end
  end
  #

  resources :dashboard, only: [:index]
  resources :home, only: [:index]

  resources :events do
    resources :ticket_types, only: [:index, :new, :create]
    resources :registrations, only: [:index, :new, :create, :show, :edit, :update] do
      resources :tickets, only: [:index, :new, :create, :show, :destroy]
    end
    resources :check_ins
  end

  # Other routes
  get "/health_check" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"
end