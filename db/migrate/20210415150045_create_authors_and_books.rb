class CreateAuthorsAndBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :authors_books, id: false do |t|
      t.belongs_to :author, index: true
      t.belongs_to :book, index: true
    end
  end
end
