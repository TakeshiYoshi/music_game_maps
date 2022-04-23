class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :twitter_id
      t.datetime :opening_time
      t.datetime :closing_time
      t.text :address
      t.references :prefecture, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end

    add_index :shops, :name, unique: true
  end
end
