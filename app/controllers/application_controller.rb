class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :refresh_user_token!

  def current_user
    @user = User.find_or_create(request.remote_ip)
  end

  def refresh_user_token!
    return if helpers.no_token_refresh_needed(current_user)

    current_user.update_token
  end
end
