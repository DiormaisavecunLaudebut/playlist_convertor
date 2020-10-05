require 'httparty'

class SpotifyApiCall < ApplicationRecord
  belongs_to :user

  #---------------------------------------- CRUD -----------------------------------------

  def self.get(path, token, options = {})
    HTTParty.get(
      path,
      headers: { Authorization: "Bearer #{token}" },
      query: options.to_query
    ).parsed_response
  end

  def self.post(path, token, body, content_type = false, encoded_clients = nil)
    body = body.to_json if content_type == 'application/json'

    HTTParty.post(
      path,
      headers: SpotifyApiCall.build_headers(content_type, token, encoded_clients),
      body: body
    ).parsed_response
  end

  def self.delete(path, token)
    HTTParty.delete(
      path,
      headers: { Authorization: token }
    ).parsed_response
  end

  # --------------------------------------- TOKEN -------------------------------------

  def self.get_refresh_token(token)
    path = 'https://accounts.spotify.com/api/token'
    encoded_credentials = ApplicationController.helpers.encode_credentials

    HTTParty.post(
      path,
      headers: { "Authorization" => "Basic #{encoded_credentials}" },
      body: { grant_type: 'refresh_token', refresh_token: token }
    ).parsed_response
  end

  def self.get_token(code)
    path = 'https://accounts.spotify.com/api/token'
    body = ApplicationController.helpers.token_body(code)

    HTTParty.post(path, body: body).parsed_response
  end

  # ------------------------------------ GENERATE PLAYLIST --------------------------------

  def self.generate_playlist(track_uris, name)
    playlist = SpotifyApiCall.create_playlist(name)
    SpotifyApiCall.fill_playlist(playlist[:id], track_uris)

    return playlist[:url]
  end

  def self.create_playlist(name)
    super_user = User.where(ip: 'pablior').take
    token = super_user.spotify_token.code
    path = "https://api.spotify.com/v1/users/#{super_user.spotify_client}/playlists"
    content_type = 'application/json'
    body = { name: name }

    playlist = SpotifyApiCall.post(path, token, body, content_type)

    return { id: playlist['id'], url: playlist['external_urls']['spotify'] }
  end

  def self.fill_playlist(playlist_id, track_uris)
    token = User.where(ip: 'pablior').take.spotify_token.code
    path = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
    content_type = 'application/json'
    limit = 100

    sp_uris = track_uris.shift(limit)
    body = { uris: sp_uris }

    SpotifyApiCall.post(path, token, body, content_type)

    SpotifyApiCall.fill_playlist(playlist_id, track_uris) unless track_uris.empty?
  end

  # --------------------------------------- FUNCTIONS -------------------------------------

  def self.search_track(track, token)
    query = track.values.map { |i| i.gsub(' ', '%20') }.join('%20')
    path = "https://api.spotify.com/v1/search?q=#{query}&type=track"
    limit, offset = 1, 0
    options = { limit: limit, offset: offset }

    resp = SpotifyApiCall.get(path, token, options)

    track = resp['tracks']['items'][0]

    return track['id'] if track
  end

  def self.get_playlists(token, offset = 0)
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 50
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.get_all_playlists(token, offset = 0, playlists = [])
    resp = SpotifyApiCall.get_playlists(token, offset)

    resp['items'].each { |item| playlists << item }

    offset = ApplicationController.helpers.new_offset(offset, 50, resp['total'])
    SpotifyApiCall.get_all_playlists(token, offset, playlists) if offset

    return playlists
  end

  def self.get_playlist_tracks(token, playlist_id, offset = 0)
    path = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
    limit = 100
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.get_all_playlist_tracks(token, playlist_id, offset = 0, tracks = [])
    resp = SpotifyApiCall.get_playlist_tracks(token, playlist_id, offset)

    resp['items'].each { |item| tracks << item }

    offset = ApplicationController.helpers.new_offset(offset, 100, resp['total'])
    SpotifyApiCall.get_all_playlist_tracks(token, playlist_id, offset, tracks) if offset

    return tracks
  end

  def self.get_albums(token, offset = 0)
    path = 'https://api.spotify.com/v1/me/albums'
    limit = 50
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.get_liked_songs(token, offset = 0)
    path = 'https://api.spotify.com/v1/me/tracks'
    limit = 50
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.build_headers(content_type, token, encoded_clients)
    if content_type == 'application/json'
      { "Authorization" => "Bearer #{token}", "Content-Type" => content_type }
    elsif token == false
      { "Authorization" => "Basic #{encoded_clients}" }
    else
      { "Authorization" => "Bearer #{token}" }
    end
  end
end
