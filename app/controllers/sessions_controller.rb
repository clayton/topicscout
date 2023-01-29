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

    session[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def allowed_params
    params.permit(:authenticity_token, :code)
  end
end
