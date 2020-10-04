module ApplicationHelper
  def encode_credentials
    client_id = ENV['SPOTIFY_CLIENT']
    client_secret = ENV['SPOTIFY_SECRET']
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def token_body(code)
    redirect_uri = Rails.env == "development" ? "http://localhost:3000/auth/spotify/callback" : ""

    {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: redirect_uri,
      client_id: ENV['SPOTIFY_CLIENT'],
      client_secret: ENV['SPOTIFY_SECRET']
    }
  end

  def new_offset(offset, limit, total)
    offset + limit < total ? offset += limit : nil
  end

  def no_token_refresh_needed(user)
    check1 = user.nil?
    check2 = user&.spotify_token.nil?
    check3 = user&.valid_token? == true

    check1 || check2 || check3
  end
end
