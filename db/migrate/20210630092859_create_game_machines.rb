class CreateGameMachines < ActiveRecord::Migration[7.0]
  def change
    create_table :game_machines do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :count, default: 0, null: false

      t.timestamps
    end

    add_index :game_machines, [:shop_id, :game_id], unique: true
  end
end
