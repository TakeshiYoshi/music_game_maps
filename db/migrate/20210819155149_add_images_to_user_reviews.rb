class AddImagesToUserReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :user_reviews, :images, :json
  end
end
