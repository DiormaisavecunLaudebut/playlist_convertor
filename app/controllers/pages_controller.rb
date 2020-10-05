class PagesController < ApplicationController
  def home
    spotify_redirect_uri = Rails.env == "development" ? "http://localhost:3000/auth/spotify/callback" : "https://playlist-convertor.herokuapp.com/auth/spotify/callback"
    deezer_redirect_uri = Rails.env == "development" ? "http://localhost:3000/auth/deezer/callback" : "https://playlist-convertor.herokuapp.com/auth/deezer/callback"
    raise
    @spotify_url = "https://accounts.spotify.com/authorize?client_id=7828af1910d047598e9ecb6308ce17c5&redirect_uri=#{CGI.escape(spotify_redirect_uri)}&response_type=code&scope=playlist-read-private+playlist-read-collaborative+playlist-modify-public+playlist-modify-private+user-library-modify+user-library-read+ugc-image-upload+user-read-private+user-read-email&show_dialog=false"
    @deezer_url = "https://connect.deezer.com/oauth/auth.php?app_id=#{ENV['DEEZER_CLIENT']}&redirect_uri=#{CGI.escape(deezer_redirect_uri)}&perms=basic_access,email,manage_library,offline_access"
  end
end
