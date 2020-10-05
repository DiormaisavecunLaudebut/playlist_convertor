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
    @playlist_name = params['info']['playlist_name']
  end

  def generate_playlist
    playlist_id = params['info']['playlist_id']
    playlist_name = helpers.clean_emoji(params['info']['playlist_name'])
    destination = params['info']['destination']

    tracks = fetch_tracks(playlist_id)
    @url = convert_playlist(tracks, destination, playlist_name)
  end

  def share_playlist
    raise
  end

  private

  def fetch_tracks(playlist_id)
    case @user.connector
    when 'deezer' then tracks = DeezerApiCall.get_playlist_track(@user.token, playlist_id)
    when 'spotify' then tracks = SpotifyApiCall.get_all_playlist_tracks(@user.token, playlist_id)
    end

    helpers.uniformise_tracks(tracks, @user.connector)
  end

  def convert_playlist(tracks, destination, name)
    case destination
    when 'deezer' then controller = DeezerController.new
    when 'spotify' then controller = SpotifyController.new
    end

    controller.request = request
    controller.response = response
    controller.convert_playlist(tracks, name)
  end
end
