class AddLocationToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :lat, :string
    add_column :shops, :lon, :string
  end
end
