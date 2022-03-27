class AddGamesInfoToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :games_info, :text
  end
end
