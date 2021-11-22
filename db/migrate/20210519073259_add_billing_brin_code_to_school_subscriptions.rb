class AddBillingBrinCodeToSchoolSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :school_subscriptions, :billing_brincode, :string
  end
end
