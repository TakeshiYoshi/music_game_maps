class RemoveColumnsFromShops < ActiveRecord::Migration[6.0]
  def up
    remove_column :shops, :opening_time
    remove_column :shops, :closing_time
  end

  def down
    add_column :shops, :opening_time
    add_column :shops, :closing_time
  end
end
