class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.string :status, default: 'active'
      t.string :stripe_subscription_id, null: false
      t.string :stripe_customer_id, null: false
      t.string :stripe_customer_email, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
