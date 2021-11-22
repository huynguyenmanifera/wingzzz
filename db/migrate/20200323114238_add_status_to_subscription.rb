class AddStatusToSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :aasm_state, :string
  end
end
