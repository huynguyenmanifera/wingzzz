class AddLayoutToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :layout, :string, required: true, default: 'two_pages'
  end
end
