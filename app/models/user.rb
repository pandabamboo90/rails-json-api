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
class User < ApplicationRecord
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable, :recoverable, :lockable

  include DeviseTokenAuth::Concerns::User
  include LockableConcern

  # Uploaders
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute

  # Enable role with Rolify gem
  rolify :before_add => :before_add_role

  def before_add_role(role)
    role.display_name = role.name
                            .split('_')
                            .join(' ')
                            .capitalize if role.display_name.blank?
  end

  # Associations
  # has_many :roles
  has_many :permissions, through: :roles

  # Validations
  validates :email, :mobile_phone, presence: true
  validates :mobile_phone, uniqueness: { case_sensitive: true }, length: 9..20, if: :mobile_phone_changed?
  # Hack to show email uniqueness error correctly instead of using Devise validation
  validates :email, uniqueness: { case_sensitive: true }, on: :update, if: :email_changed?
end
