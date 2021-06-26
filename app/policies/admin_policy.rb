class AdminPolicy < ApplicationPolicy
  # == Info ==
  # `user` is a performing subject,
  # `record` is a target object (model we want to update)

  def index?
    admin?
  end

  def show?
    # Only owner can see detail
    admin? || owner_updating_itself?
  end

  def update?
    # Only owner can see update
    admin? || owner_updating_itself?
  end
end
