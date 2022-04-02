class RenameLonColumnToShops < ActiveRecord::Migration[7.0]
  def change
    rename_column :shops, :lon, :lng
  end
end
