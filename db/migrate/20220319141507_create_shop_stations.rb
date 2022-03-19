class CreateShopStations < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_stations do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :station, null: false, foreign_key: true
      t.timestamps
    end

    add_index :shop_stations, [:shop_id, :station_id], unique: true
  end
end
