class AddTrendingNowPositionToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :trending_now_position, :integer, limit: 1
  end
end
