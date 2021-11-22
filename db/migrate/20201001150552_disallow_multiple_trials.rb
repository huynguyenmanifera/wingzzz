class DisallowMultipleTrials < ActiveRecord::Migration[6.0]
  def change
    remove_index :trials, :user_id
    add_index :trials, :user_id, unique: true
  end
end
