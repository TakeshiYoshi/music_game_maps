class AddOpeningHoursTextToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :opening_hours_text, :text
  end
end
