class Admin::UsersController < AdminController
  def index
    @users = User.all.order(email: :asc)
  end

  def show
    @user = User.find(params[:id])
    session[:admin_id] = current_user.id
    session[:user_id] = @user.id

    redirect_to topics_url
  end
end
