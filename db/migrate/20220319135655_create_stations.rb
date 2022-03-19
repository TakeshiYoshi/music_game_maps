class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.decimal :lat, precision: 10, scale: 7
      t.decimal :lng, precision: 10, scale: 7
      t.references :prefecture, null: false, foren_key: true
      t.references :line, null: false, foren_key: true
      t.timestamps
    end

    add_index :stations, :name, unique: true
  end
end
