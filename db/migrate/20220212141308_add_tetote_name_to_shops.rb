class AddTetoteNameToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :tetote_name, :string
  end
end
