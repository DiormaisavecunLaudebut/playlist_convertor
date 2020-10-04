class DeezerController < ApplicationController
  def connect_user
    current_user.update!(connector: 'deezer')
  end

  def generate_playlist_from_spotify
    # search tracks using artist and track_name
    # create Deezer playlist
    # append playlist with tracks
  end
end
