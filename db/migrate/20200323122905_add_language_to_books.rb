class AddLanguageToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :language, :string, required: true, default: 'en-US'
    add_index :books, :language
  end
end
