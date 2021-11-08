class CreateShopHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_histories do |t|
      t.string :name
      t.string :phone_number
      t.string :website
      t.string :twitter_id
      t.json :games
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.timestamps
    end
  end
end
