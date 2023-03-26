class EmailAuthenticationsController < ApplicationController
  layout 'sessions'
  before_action :lookup_user, only: [:create]

  before_action :check_for_remembered_session, only: [:new]


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

  protected



  def check_for_remembered_session
    remember_me = cookies.encrypted[:remember_me]
    return true if remember_me.nil? || remember_me.empty?

    lookup, validator = remember_me.split('.')
    remembered_session = RememberedSession.find_by(lookup: lookup, validator: validator)

    if remembered_session&.user
      session[:user_id] = remembered_session.user_id
      redirect_to session[:return_to] || root_url
      return false
    end

    true
  end
end
