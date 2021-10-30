class AddColumnToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :konami_name, :string
    add_column :shops, :sega_name, :string
    add_column :shops, :namco_name, :string
    add_column :shops, :taito_name, :string
  end
end
