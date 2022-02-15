class UserReviewForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :body, :string
  attribute :user_id, :integer
  attribute :shop_id, :integer

  validates :body, presence: true, length: { maximum: 1000 }

  attr_accessor :games, :images

  def save
    return false if invalid?

    user_review = UserReview.new(body:, user_id:, shop_id:, images: images_format(images))
    games.each_key { |game_id| user_review.about_games.build(game_id:) } if games.present?

    user_review.save!

    true
  end

  private

  def images_format(images)
    images&.slice(0..(UserReview::MAX_IMAGE_COUNT - 1))
  end
end
