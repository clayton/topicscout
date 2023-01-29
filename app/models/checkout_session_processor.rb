class CheckoutSessionProcessor
  def initialize(checkout_session_id: nil, user_id: nil)
    @checkout_session_id = checkout_session_id
    @user_id = user_id
  end

  def save
    
    @checkout_session = Stripe::Checkout::Session.retrieve({id: @checkout_session_id, expand: ['customer', 'subscription']})

    raise CheckoutSessionProcessor::CheckoutNotFound unless @checkout_session

    # Rails.logger.debug(@checkout_session)

    @customer = @checkout_session['customer']

    raise CheckoutSessionProcessor::CustomerNotFound unless @customer

    @user = User.find_or_create_by(email: @customer['email']) do |user|
      user.name = @customer['name']
    end

    @sub = @checkout_session['subscription']

    @subscription = Subscription.create!(
      user_id: @user.id,
      stripe_checkout_session_id: @checkout_session['id'],
      stripe_subscription_id: @sub['id'],
      stripe_customer_id: @customer['id'],
      status: @sub['status'],
      stripe_customer_email: @customer['email']
    )
  end

  class CustomerNotFound < StandardError
  end

  class CheckoutNotFound < StandardError
  end
end
