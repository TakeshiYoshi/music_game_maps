class RenameLonColumnToShops < ActiveRecord::Migration[6.0]
  def change
    rename_column :shops, :lon, :lng
  end
end
