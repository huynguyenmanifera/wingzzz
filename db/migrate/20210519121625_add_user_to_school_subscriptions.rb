class AddUserToSchoolSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :school_subscriptions, :user, index: true
  end
end
