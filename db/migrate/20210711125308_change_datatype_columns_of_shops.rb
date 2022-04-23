class ChangeDatatypeColumnsOfShops < ActiveRecord::Migration[7.0]
  def change
    rename_column :shops, :lat, :lat_old
    rename_column :shops, :lng, :lng_old
    add_column :shops, :lat, :decimal, precision: 10, scale: 7
    add_column :shops, :lng, :decimal, precision: 10, scale: 7
  end
end
