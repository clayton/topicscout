class AddStripeCheckoutSessionIdToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :stripe_checkout_session_id, :string, null: false
  end
end
