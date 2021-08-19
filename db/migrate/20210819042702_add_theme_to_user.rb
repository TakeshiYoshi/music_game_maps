class AddThemeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :theme, :string
  end
end
