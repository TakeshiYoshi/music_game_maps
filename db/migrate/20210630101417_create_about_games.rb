class CreateAboutGames < ActiveRecord::Migration[6.0]
  def change
    create_table :about_games do |t|
      t.references :user_review, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :about_games, [:user_review_id, :game_id], unique: true
  end
end
