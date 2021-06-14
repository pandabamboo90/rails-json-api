# frozen_string_literal: true

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
class Role < ApplicationRecord
  # Enable role with Rolify gem
  scopify

  # Associations
  has_and_belongs_to_many :users, join_table: :users_roles
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
  belongs_to :resource,
             polymorphic: true,
             optional: true

  # Validations
  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true
  validates_presence_of :name, :display_name
end
