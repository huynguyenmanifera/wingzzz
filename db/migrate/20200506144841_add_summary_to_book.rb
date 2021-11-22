class AddSummaryToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :summary, :string, limit: 1_024
  end
end
