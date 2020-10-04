class SpotifyToken < ApplicationRecord
  belongs_to :user

  def self.create_token(user, code)
    resp = SpotifyApiCall.get_token(code)

    SpotifyToken.create!(
      user: user,
      expires_at: Time.now + resp['expires_in'],
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end

  def self.update_or_create(user, code)
    token = user.spotify_token

    token ? token.update_token : SpotifyToken.create_token(user, code)
  end

  def update_token
    resp = SpotifyApiCall.get_refresh_token(refresh_token)

    update!(
      expires_at: Time.now + resp['expires_in'],
      code: resp['access_token']
    )
  end
end
