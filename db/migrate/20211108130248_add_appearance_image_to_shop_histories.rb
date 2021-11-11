class AddAppearanceImageToShopHistories < ActiveRecord::Migration[6.0]
  def change
    add_column :shop_histories, :appearance_image, :string
  end
end
