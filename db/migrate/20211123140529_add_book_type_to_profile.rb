class AddBookTypeToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :book_type, :integer, default: 0
  end
end
