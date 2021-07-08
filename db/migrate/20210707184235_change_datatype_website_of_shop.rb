class ChangeDatatypeWebsiteOfShop < ActiveRecord::Migration[6.0]
  def change
    change_column :shops, :website, :text
  end
end
