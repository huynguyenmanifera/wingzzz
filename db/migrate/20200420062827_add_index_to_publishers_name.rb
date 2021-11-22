class AddIndexToPublishersName < ActiveRecord::Migration[6.0]
  def change
    add_index :publishers, :name, unique: true
  end
end
