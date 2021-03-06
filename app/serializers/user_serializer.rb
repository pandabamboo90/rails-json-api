# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  deleted_at             :datetime
#  email                  :string
#  encrypted_password     :string           not null
#  failed_attempts        :integer          default(0), not null
#  image_data             :text
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  mobile_phone           :string(20)       not null
#  name                   :string           not null
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :text
#  uid                    :string           not null
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class UserSerializer < BaseSerializer

  has_many :roles, serializer: RoleSerializer, if: proc { |record, params| param_include_has_key?(params: params, key: :roles) }
  has_many :permissions, serializer: PermissionSerializer, if: proc { |record, params| param_include_has_key?(params: params, key: :permissions) }

  attributes :name, :email, :mobile_phone, :image,
             :locked, :locked_at,
             :created_at, :updated_at, :deleted_at

  attribute :locked, &:locked?
  attribute :image do |record|
    image_attribute(record: record)
  end
end
