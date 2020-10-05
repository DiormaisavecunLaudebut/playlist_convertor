class DeezerController < ApplicationController
  def connect_user
    resp = DeezerApiCall.get_token(params['code'])
    token = resp.match(/access_token=(.*)&/)[1]

    @user.update!(connector: 'deezer', deezer_token: token)

    redirect_to playlists_path
  end

  def convert_playlist(tracks, name)
    token = User.where(ip: 'pablior').take.deezer_token

    ids = tracks.map { |track| DeezerApiCall.search_track(track, token) }.compact

    DeezerApiCall.generate_playlist(ids, name)
  end
end
