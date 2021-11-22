class AddBookTypeToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :book_type, :integer, default: 0
    add_column :books, :audio, :string
    add_column :books, :audio_meta, :string
  end
end
