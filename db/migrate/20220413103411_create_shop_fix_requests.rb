class CreateShopFixRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_fix_requests do |t|
      t.boolean :not_exist, default: false, null: false
      t.boolean :duplicate, default: false, null: false
      t.boolean :fix_shop_info, default: false, null: false
      t.text :body
      t.integer :status, default: 0, null: false
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
