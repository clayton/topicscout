class Onboarding::TwitterAccountsController < ApplicationController
  layout 'onboarding'
  before_action :check_for_existing_account

  def new
  end

  def create
  end

  def check_for_existing_account
    redirect_to onboarding_first_topic_url and return if current_user.twitter_account.present?
  end
end
