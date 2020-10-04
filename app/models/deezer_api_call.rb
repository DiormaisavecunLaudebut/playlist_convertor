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
end
