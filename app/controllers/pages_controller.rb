class PagesController < ApplicationController
  def home
    @spotify_url = "https://accounts.spotify.com/authorize?client_id=7828af1910d047598e9ecb6308ce17c5&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fspotify%2Fcallback&response_type=code&scope=playlist-read-private+playlist-read-collaborative+playlist-modify-public+playlist-modify-private+user-library-modify+user-library-read+ugc-image-upload+user-read-private+user-read-email&show_dialog=false"
    @deezer_url = ""
  end
end
