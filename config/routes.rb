Rails.application.routes.draw do
  devise_for :artists
  devise_for :users
  root to: "pages#home"
  resources :search, only: :index
  resources :shortlists
  resources :artists do
    resources :shortlisted_artists, only: :create
    resources :artworks, only: :destroy
  end
  resources :shortlisted_artists
  resources :users
  resources :artworks, except: :show
  resources :opportunities do
    resources :applications, only: %i[destroy toggle_success new create]
  end
  resources :applications, except: :edit do
    member do
      patch :toggle_success
    end
  end

  get "/my-opportunities", to: "opportunities#mine"
end
