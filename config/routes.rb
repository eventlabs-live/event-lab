Rails.application.routes.draw do
  # Devise routes
  devise_for :users

  # User routes
  resources :users, only: [:new, :index, :show, :edit, :update] do
    resources :ticket_types, except: [:show, :index]
    resources :event_registrations, only: [ :index], as: 'my_registrations'
  end

  # Check-in routes
  resources :check_ins, only: [:index, :create]
  resources :tickets, only: [:show]

  # Other EventRegistrations
  resources :tickets, only: [:index, :show, :new, :create] do
    resources :event_registrations, only: [:new, :create, :index, :show] do
      resources :payments, only: [:new, :create, :show]
    end
  end
  #

  resources :dashboard, only: [:index]
  resources :home, only: [:index]

  resources :events do
    member do
      get 'edit_status'
      patch 'update_status'
    end
    resources :ticket_types, only: [:index, :new, :create]
    resources :event_registrations, only: [:index, :new, :create, :show, :edit, :update] do
      resources :tickets, only: [:index, :new, :create, :show, :destroy]
    end
    member do
      patch :save_draft
    end
    collection do
      post "next_step"
    end
    resources :check_ins
  end

  get "booked_for" => "event_registrations#booked_for", as: :booked_for

  # Other routes
  get "/health_check" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"
end