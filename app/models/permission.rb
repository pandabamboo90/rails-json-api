# == Schema Information
#
# Table name: permissions
#
#  id              :bigint           not null, primary key
#  action_name     :string           not null
#  controller_path :string           not null
#  description     :text
#  display_name    :string           not null
#  method          :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  idx_1  (method,controller_path,action_name) UNIQUE
#
class Permission < ApplicationRecord
  # Associations
  has_many :role_permissions
  has_many :roles, through: :role_permissions

  # Validations
  validates_presence_of :display_name, :method, :controller_path, :action_name

  # Scopes
  # ...

  # Callbacks
  # ...
end
