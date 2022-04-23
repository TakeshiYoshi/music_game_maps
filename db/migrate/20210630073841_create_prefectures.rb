class CreatePrefectures < ActiveRecord::Migration[7.0]
  def change
    create_table :prefectures do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :prefectures, :name, unique: true
  end
end
