# Base class for application policies
class ApplicationPolicy < ActionPolicy::Base

  # Configure additional authorization contexts here
  # (`user` is added by default).
  #
  #   authorize :account, optional: true
  #
  # Read more about authorization context: https://actionpolicy.evilmartians.io/#/authorization_context

  private

  # Define shared methods useful for most policies.
  # For example:
  #
  # def owner?
  #   record.user_id == user.id
  # end

  def admin?
    user.is_a?(Admin)
  end

  def owner_updating_itself?
    user.id == record.id
  end
end
