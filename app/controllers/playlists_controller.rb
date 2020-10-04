class PlaylistsController < ApplicationController
  def index
    case @user.connector
    when 'spotify' then playlists = SpotifyApiCall.get_all_playlists(@user.token)
    when 'deezer' then playlists = DeezerApiCall.get_playlists(@user.deezer_token)
    end

    @playlists = helpers.uniformise_playlists(playlists, @user.connector)
  end

  def destination
    @playlist_id = params['info']['playlist_id']
  end

  def convert_playlist
    playlist_id = params['info']['playlist_id']
    destination = params['info']['destination']

    case @user.connector
    when 'deezer' then tracks = DeezerApiCall.get_playlist_track(@user.token, playlist_id)
    when 'spotify' then tracks = SpotifyApiCall.get_all_playlist_tracks(@user.token, playlist_id)
    end
    raise

    @tracks = helpers.uniformise_tracks(tracks)
  end
end
