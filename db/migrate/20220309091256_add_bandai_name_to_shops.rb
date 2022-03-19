class AddBandaiNameToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :bandai_name, :string
  end
end
