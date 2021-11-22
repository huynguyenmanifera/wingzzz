class AddCheckoutUrlToSubscriptionn < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :checkout_url, :string, limit: 2_048
  end
end
