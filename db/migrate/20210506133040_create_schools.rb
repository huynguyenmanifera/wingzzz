class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :address
      t.string :postcode
      t.string :city
      t.string :brin_code
    end
  end
end
