class AddIndexToTrendingNowPosition < ActiveRecord::Migration[6.0]
  def change
    add_index(:books, :trending_now_position)
  end
end
