class AuthenticatedUserController < ApplicationController
  before_action :require_authenticated_user
  before_action :check_for_new_user

  private

  def require_authenticated_user
    return if current_user

    redirect_to login_url
  end

  def check_for_new_user
    redirect_to onboarding_start_url if current_user.topics.empty?
  end
end
