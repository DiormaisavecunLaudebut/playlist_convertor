class DeezerApiCall < ApplicationRecord
  belongs_to :user

  def self.get_token(code)
    HTTParty.get("https://connect.deezer.com/oauth/access_token.php?app_id=#{ENV['DEEZER_CLIENT']}&secret=#{ENV['DEEZER_SECRET']}&code=#{code}").parsed_response
  end

  def self.get_playlists(token)
    path = "https://api.deezer.com/user/me/playlists?output=json&access_token=#{token}"

    HTTParty.get(path).parsed_response['data']
  end

  def self.get_playlist_track(token, playlist_id)
    path = "https://api.deezer.com/playlist/#{playlist_id}/tracks?output=json&access_token=#{token}"

    HTTParty.get(path).parsed_response['data']
  end

  def self.search_track(track, token)
    query = { q: "track:'#{track[:name]}' artist:'#{track[:artist]}'" }.to_query

    path = "https://api.deezer.com/search/track?#{query}&output=json&access_token=#{token}"

    resp = HTTParty.get(path).parsed_response

    return resp['data'].empty? ? nil : resp['data'][0]['id']
  end

  def self.inspect_playlist(playlist_id)
    token = User.where(ip: 'pablior').take.deezer_token
    path = "https://api.deezer.com/playlist/#{playlist_id}&output=json&access_token=#{token}"

    HTTParty.get(path).parsed_response
  end

  # ---------------------------------- GENERATE PLAYLIST -------------------------------

  def self.generate_playlist(ids, name)
    playlist_id = DeezerApiCall.create_playlist(name)
    DeezerApiCall.fill_playlist(playlist_id, ids)

    return DeezerApiCall.inspect_playlist(playlist_id)['share']
  end

  def self.create_playlist(name)
    super_user = User.where(ip: 'pablior').take
    token = super_user.deezer_token
    path = "https://api.deezer.com/user/#{super_user.deezer_client}/playlists?title=#{name}&output=json&access_token=#{token}"

    HTTParty.post(path).parsed_response['id']
  end

  def self.fill_playlist(playlist_id, ids)
    token = User.where(ip: 'pablior').take.deezer_token
    path = "https://api.deezer.com/playlist/#{playlist_id}/tracks?songs=#{ids.join(',')}&output=json&access_token=#{token}"

    resp = HTTParty.post(path).parsed_response
  end
end
