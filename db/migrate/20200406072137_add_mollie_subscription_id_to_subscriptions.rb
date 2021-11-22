class AddMollieSubscriptionIdToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :mollie_subscription_id, :string
  end
end
