class User < ApplicationRecord
  has_one :spotify_token

  def self.find_or_create(ip)
    User.where(ip: ip).take || User.create(ip: ip)
  end

  def update_token
    case connector
    when 'spotify' then spotify_token.update(token)
    # when 'deezer' then deezer_token.update(token)
    end
  end

  def token
    spotify_token.code
  end

  def valid_token?
    return if spotify_token.nil?

    spotify_token.expires_at >= Time.now
  end
end
