class AuthenticatedUserController < ApplicationController
  before_action :require_authenticated_user

  private

  def require_authenticated_user
    return if current_user

    redirect_to login_url
  end
end
