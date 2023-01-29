class EmailAuthenticationsController < ApplicationController
  layout 'sessions'
  before_action :lookup_user, only: [:create]

  def new
  end

  def create
    @authentication = @user.email_authentications.create
    @authentication.send_code
  end

  def authenticated_params
    params.permit(:email, :authenticity_token)
  end

  def lookup_user
    @user = User.find_by(email: authenticated_params[:email])
    return true if @user
    flash[:error] = "We could not find that email."
    redirect_to login_url and return

  end
end
