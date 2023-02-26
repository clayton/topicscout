class TwitterAccountsController < AuthenticatedUserController
  def create
    TwitterAccount.find_or_create_from_auth_hash(auth_hash.merge(user_id: current_user.id))
    if current_user.onboarding?
      redirect_to onboarding_first_topic_url
    else
      redirect_to profile_url
    end
  end

  def destroy
    @twitter_account = current_user.twitter_account
    @twitter_account.destroy

    redirect_to profile_url
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
