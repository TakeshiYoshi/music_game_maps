class CreateStationCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :station_companies do |t|
      t.string :name, null: false
      t.integer :code

      t.timestamps
    end
  end
end
