Rails.application.routes.draw do
  root to: 'pages#home'
  resources :playlists, only: [:index] do
  end

  get 'auth/spotify/callback', to: 'spotify#connect_user'
  get 'auth/deezer/callback', to: 'deezer#connect_user'

  get 'select-destination', to: 'playlists#destination', as: :destination
  get 'share-playlist', to: 'playlists#share_playlist', as: :share_playlist

  get 'convert-playlist', to: 'playlists#generate_playlist', as: :generate_playlist
end
