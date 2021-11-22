class AddAgeRangeToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :min_age_in_months, :integer, limit: 2
    add_column :books, :max_age_in_months, :integer, limit: 2
  end
end
