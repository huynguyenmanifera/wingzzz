class AddGracePeriodEndsOnToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :grace_period_ends_on, :date
  end
end
