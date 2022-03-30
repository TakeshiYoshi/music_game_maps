class CreateStationLines < ActiveRecord::Migration[7.0]
  def change
    create_table :station_lines do |t|
      t.string :name, null: false
      t.integer :code
      t.references :station_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
