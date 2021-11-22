class AddIndexToSchoolsBrinCode < ActiveRecord::Migration[6.0]
  def change
    add_index :schools, :brin_code, unique: true
  end
end
