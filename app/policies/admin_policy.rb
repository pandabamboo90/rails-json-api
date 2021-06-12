class AdminPolicy < ApplicationPolicy
  # == Info ==
  # `user` is a performing subject,
  # `record` is a target object (model we want to update)

  def index?
    user.admin?
  end

  def show?
    # Only owner can see detail
    user.id == record.id
  end

  def update?
    # Only owner can see update
    user.id == record.id
  end
end
