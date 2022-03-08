class AddTakaraNameToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :takara_name, :string
  end
end
