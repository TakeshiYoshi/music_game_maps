class AddOpeningHoursTextToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :opening_hours_text, :text
  end
end
