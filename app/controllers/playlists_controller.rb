class PlaylistsController < ApplicationController
  def index
    case @user.connector
    when 'spotify' then playlists = SpotifyApiCall.get_all_playlists(@user.token)
    when 'deezer' then playlists = DeezerApiCall.get_playlists(@user.deezer_token)
    end

    @playlists = helpers.uniformise_playlists(playlists, @user.connector)
  end

  def destination
    playlist_id = params['format']
  end
end
