class AddPhotoUrlToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :photo_url, :string
    add_column :shops, :photo_url_update_at, :datetime
  end
end
