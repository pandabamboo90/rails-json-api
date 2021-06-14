class RolePermission < ApplicationRecord
  self.table_name = "roles_permissions"

  # Associations
  belongs_to :role
  belongs_to :permission

  # Validations
  # ...

  # Scopes
  # ...

  # Callbacks
  # ...
end
