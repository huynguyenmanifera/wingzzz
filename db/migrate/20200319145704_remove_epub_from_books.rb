class RemoveEpubFromBooks < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :epub
  end
end
