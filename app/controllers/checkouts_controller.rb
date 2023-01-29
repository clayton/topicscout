class CheckoutsController < ApplicationController
  def show
    begin
      @processor = CheckoutSessionProcessor.new(
        checkout_session_id: params[:checkout_session_id],
        user_id: session[:user_id]
      )
      @subscription = @processor.save

      session[:user_id] = @subscription.user.id
    rescue CheckoutSessionProcessor::CustomerNotFound
      Honeybadger.notify("Customer not found for checkout: #{params[:checkout_session_id]}")
      flash[:error] = 'There was an error creating your account. Contact help@topicscout.app.'
    rescue CheckoutSessionProcessor::CheckoutNotFound
      Honeybadger.notify("Checkout session not found: #{params[:checkout_session_id]}")
      flash[:error] = 'There was an error creating your account. Contact help@topicscout.app.'
    end

    redirect_to onboarding_start_url
  end
end
