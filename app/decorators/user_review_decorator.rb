# frozen_string_literal: true

module UserReviewDecorator
  def own?(user)
    self.user == user
  end
end
