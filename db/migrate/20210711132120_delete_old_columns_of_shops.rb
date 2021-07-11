class DeleteOldColumnsOfShops < ActiveRecord::Migration[6.0]
  def change
    remove_column :shops, :lat_old, :string
    remove_column :shops, :lng_old, :string
  end
end
