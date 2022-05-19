class SessionsController < ApplicationController

  def new

  end

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    
    if session[:topic_id]
      @topic = Topic.find_by(id: session[:topic_id])
      @interest = Interest.find_or_create_by(topic: @topic, user: @user)
    end

    session[:user_id] = @user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
