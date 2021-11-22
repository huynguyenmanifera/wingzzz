class CreateTrials < ActiveRecord::Migration[6.0]
  def change
    create_table :trials do |t|
      t.date :expires_after
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
