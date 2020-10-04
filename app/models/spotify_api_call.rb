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
    call = SpotifyApiCall.create(path: user)

    body = body.to_json if content_type == 'application/json'

    HTTParty.post(
      path,
      headers: call.build_headers(content_type, token, encoded_clients),
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

  # --------------------------------------- FUNCTIONS -------------------------------------

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

  def build_headers(content_type, token)
    if content_type == 'application/json'
      { "Authorization" => token, "Content-Type" => content_type }
    elsif token == false
      { "Authorization" => "Basic #{encoded_clients}" }
    else
      { "Authorization" => token }
    end
  end
end
