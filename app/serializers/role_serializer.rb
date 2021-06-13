# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  display_name  :string           not null
#  name          :string           not null
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :bigint
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
class RoleSerializer < BaseSerializer
  attributes :name, :display_name, :resource_type, :resource_id
end
