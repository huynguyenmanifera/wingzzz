class AddAgeRangeToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :min_age_in_months, :integer, limit: 2
    add_column :profiles, :max_age_in_months, :integer, limit: 2
  end
end
