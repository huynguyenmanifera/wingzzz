class CreateSchoolSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :school_subscriptions do |t|
      t.string :contact_name
      t.string :contact_email
      t.string :billing_name
      t.string :billing_address
      t.string :billing_postcode
      t.string :billing_city
      t.date :end_date
      t.references :school, null: false, foreign_key: true
    end
  end
end
