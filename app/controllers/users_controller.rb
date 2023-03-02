class UsersController < AuthenticatedUserController

  before_action :verify_email, only: [:edit]

  def edit
    @twitter_account = current_user.twitter_account
    @subscription = current_user.subscription
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
    params.require(:user).permit(:email, :name, :timezone)
  end

  def verify_email
    return if current_user.email_verified?
    return if current_user.email_verifications.pending.any?

    current_user.verify_email
  end
end
