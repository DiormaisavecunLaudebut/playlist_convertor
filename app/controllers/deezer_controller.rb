class DeezerController < ApplicationController
  def connect_user
    resp = DeezerApiCall.get_token(params['code'])
    token = resp.match(/access_token=(.*)&/)[1]

    current_user.update!(connector: 'deezer', deezer_token: token)

    redirect_to playlists_path
  end

  def generate_playlist
    # search tracks using artist and track_name
    # create Deezer playlist
    # append playlist with tracks
  end
end
