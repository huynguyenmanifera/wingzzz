class CreateBookSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :book_sessions do |t|
      t.references :profile
      t.references :book
      t.integer :current_page

      t.timestamps
    end
  end
end
