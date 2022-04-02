class ChangeDatatypeWebsiteOfShop < ActiveRecord::Migration[7.0]
  def change
    change_column :shops, :website, :text
  end
end
