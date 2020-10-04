class PlaylistsController < ApplicationController
  def index
    @playlists = SpotifyApiCall.get_all_playlists(current_user.token)
  end

  def destination
    playlist_id = params['format']
  end
end
