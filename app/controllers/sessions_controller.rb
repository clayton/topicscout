class SessionsController < ApplicationController
  def new; end

  def create
    @email_authentication = EmailAuthentication.valid.find_by(code: allowed_params[:code])

    if @email_authentication.nil?
      flash[:error] = 'Sorry, we could not verify that code.'
      redirect_to login_url and return
    end

    @user = @email_authentication.user

    if session[:topic_id]
      @topic = Topic.find_by(id: session[:topic_id])
      @topic&.update(user: @user)
    end

    remember_user(@user)
    session[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    cleanup_remembered_session
    @current_user = nil
    @current_organization = nil
    session[:user_id] = nil
    cookies.encrypted[:user_id] = nil
    reset_session
    redirect_to login_url
  end

  private

  def remember_user(_user)
    return unless allowed_params[:remember_me]

    @remembered_session = @user.remembered_sessions.create

    cookies.encrypted[:remember_me] = {
      value: @remembered_session.cookie_value,
      expires: 30.days.from_now,
      domain: request.host
    }
  end

  def cleanup_remembered_session
    remember_me = cookies.encrypted[:remember_me]
    return if remember_me.nil? || remember_me.empty?

    lookup, validator = remember_me.split('.')
    RememberedSession.delete_by(lookup: lookup, validator: validator)
    cookies.delete(:remember_me, domain: request.host)
  end

  def allowed_params
    params.permit(:authenticity_token, :code, :remember_me)
  end
end
