Rails.application.routes.draw do
  root to: 'pages#home'
  resources :playlists, only: [:index] do
  end

  get 'auth/spotify/callback', to: 'spotify#connect_user'
  get 'auth/deezer/callback', to: 'deezer#connect_user'

  get 'select-destination', to: 'playlists#destination', as: :destination

  get 'convert-playlist', to: 'playlists#convert_playlist', as: :convert_playlist
end
