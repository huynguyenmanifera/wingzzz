class AddIndexBookSessions < ActiveRecord::Migration[6.0]
  def change
    add_index :book_sessions, :updated_at
  end
end
