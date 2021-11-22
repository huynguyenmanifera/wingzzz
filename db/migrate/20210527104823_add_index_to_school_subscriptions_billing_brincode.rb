class AddIndexToSchoolSubscriptionsBillingBrincode < ActiveRecord::Migration[
  6.0
]
  def change
    add_index :school_subscriptions, :billing_brincode, unique: true
  end
end
