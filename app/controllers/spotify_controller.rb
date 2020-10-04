class SpotifyController < ApplicationController
  def connect_user
    current_user.update!(connector: 'spotify')
    SpotifyToken.update_or_create(current_user, params['code'])

    redirect_to playlists_path
  end
end
