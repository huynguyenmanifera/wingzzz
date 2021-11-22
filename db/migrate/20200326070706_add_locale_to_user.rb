class AddLocaleToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :locale, :string, required: true, default: 'en'
  end
end
