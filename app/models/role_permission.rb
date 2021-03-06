# == Schema Information
#
# Table name: roles_permissions
#
#  id            :bigint           not null, primary key
#  permission_id :bigint           not null
#  role_id       :bigint           not null
#
# Indexes
#
#  index_roles_permissions_on_permission_id              (permission_id)
#  index_roles_permissions_on_role_id                    (role_id)
#  index_roles_permissions_on_role_id_and_permission_id  (role_id,permission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (permission_id => permissions.id)
#  fk_rails_...  (role_id => roles.id)
#
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
