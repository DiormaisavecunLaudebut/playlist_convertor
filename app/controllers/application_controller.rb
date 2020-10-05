class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :refresh_user_token!

  def current_user
    @user = User.find_or_create(request.remote_ip)
  end

  def refresh_user_token!
    return if helpers.no_token_refresh_needed(@user)

    @user.update_token
  end

  def super_user_token
    super_user = User.where(ip: 'pablior').take
    super_user.spotify_token.update_token

    return super_user.spotify_token.code
  end
end
