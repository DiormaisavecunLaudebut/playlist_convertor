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

  def uniformise_playlists(playlists, connector)
    case connector
    when 'spotify'
      cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
      playlists.map do |i|
        cover_url = i['images'].empty? ? cover_placeholder : i['images'][0]['url']
        {
          name: i['name'],
          track_count: i['tracks']['total'],
          cover_url: cover_url,
          id: i['id']
        }
      end
    when 'deezer'
      playlists.map { |i| { name: i['title'], track_count: i['nb_tracks'], cover_url: i['picture'], id: i['id'] } }
    end
  end

  def uniformise_tracks(tracks, connector)
    case connector
    when 'spotify' then tracks.map { |i| { name: i['track']['name'], artist: i['track']['artists'][0]['name'] } }
    when 'deezer' then tracks.map { |i| { name: i['title'], artist: i['artist']['name'] } }
    end
  end

  def new_offset(offset, limit, total)
    offset + limit < total ? offset += limit : nil
  end

  def no_token_refresh_needed(user)
    check1 = user.nil?
    check2 = user&.spotify_token.nil?
    check3 = user&.valid_token? == true
    check4 = user.connector != 'spotify'

    check1 || check2 || check3 || check4
  end
end
