class CreatePlayingGames < ActiveRecord::Migration[6.0]
  def change
    create_table :playing_games do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :playing_games, [:user_id, :game_id], unique: true
  end
end
