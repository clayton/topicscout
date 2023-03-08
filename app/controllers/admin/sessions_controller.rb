class Admin::SessionsController < AdminController
  def destroy
    session[:user_id] = session[:admin_user_id]
    session[:admin_id] = nil
    redirect_to root_path
  end
end
