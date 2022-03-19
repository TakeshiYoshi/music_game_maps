class AddDistanceToShopStations < ActiveRecord::Migration[7.0]
  def change
    add_column :shop_stations, :distance, :string
  end
end
