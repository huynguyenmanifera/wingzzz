class AddEpubToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :epub, :string
  end
end
