class AddAppearanceImageToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :appearance_image, :string
  end
end
