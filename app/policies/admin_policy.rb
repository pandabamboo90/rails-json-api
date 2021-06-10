class AdminPolicy < ApplicationPolicy
  def index?
    true
  end

  # everyone can see any post
  def show?
    true
  end

  def update?
    # `user` is a performing subject,
    # `record` is a target object (post we want to update)
    user.admin? || (user.id == record.user_id)
  end
end
