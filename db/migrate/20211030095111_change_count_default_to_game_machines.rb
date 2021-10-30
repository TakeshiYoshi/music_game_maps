class ChangeCountDefaultToGameMachines < ActiveRecord::Migration[6.0]
  def change
    change_column_default :game_machines, :count, from: 0, to: 99
  end
end
