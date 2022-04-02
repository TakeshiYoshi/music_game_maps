class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.integer :code
      t.references :line, null: false, foreign_key: true
      t.integer :index_number
      t.decimal :lat, precision: 10, scale: 7
      t.decimal :lng, precision: 10, scale: 7
      t.references :prefecture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
