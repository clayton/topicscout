class UsersController < AuthenticatedUserController
  def edit
  end

  def update
    if current_user.update(user_params)
      flash[:success] = 'Your profile has been updated.'
      redirect_to root_path
    else
      flash[:error] = 'There was an error updating your profile.'
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
