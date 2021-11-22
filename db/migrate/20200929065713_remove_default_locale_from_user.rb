class RemoveDefaultLocaleFromUser < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :locale, nil
  end
end
