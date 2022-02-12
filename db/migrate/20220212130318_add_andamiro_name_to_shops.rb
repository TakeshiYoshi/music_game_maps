class AddAndamiroNameToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :andamiro_name, :string
  end
end
