class AddColumnsToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :opening_hours, :text
    add_column :shops, :phone_number, :string
    add_column :shops, :website, :string
    add_column :shops, :photo_reference, :string
    add_column :shops, :place_id, :string
  end
end
