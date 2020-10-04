Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :playlists, only: [:index] do
  end

  get 'auth/spotify/callback', to: 'spotify#connect_user'
  get 'auth/deezer/callback', to: 'deezer#connect_user'
  get 'select-destination', to: 'playlists#destination', as: :destination
end
