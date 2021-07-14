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
class PermissionSerializer < BaseSerializer
  attributes :display_name, :description
end
