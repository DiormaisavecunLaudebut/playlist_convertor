class SpotifyController < ApplicationController
  def connect_user
    @user.update!(connector: 'spotify')
    SpotifyToken.update_or_create(@user, params['code'])

    redirect_to playlists_path
  end

  def convert_playlist(tracks, name)
    token = super_user_token

    ids = tracks.map { |track| SpotifyApiCall.search_track(track, token) }

    track_uris = ids.compact.to_spotify_uri

    SpotifyApiCall.generate_playlist(track_uris, name)
  end
end

class Array
  def to_spotify_uri
    map { |id| "spotify:track:#{id}" }
  end
end
