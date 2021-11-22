class AddReaderOptionsToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :reader, :integer, default: 0
  end
end
