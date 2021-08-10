class UserPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def show?
    true
  end

  def edit_profile?
    user == record
  end

  def update_profile?
    user == record
  end

  def activate
    true
  end
end
