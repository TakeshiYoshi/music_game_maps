class AddStatusToShopHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :shop_histories, :status, :integer, null: false, default: 0
  end
end
