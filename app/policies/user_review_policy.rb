class UserReviewPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    user == record.user
  end
end
