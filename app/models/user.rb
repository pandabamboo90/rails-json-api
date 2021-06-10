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
#  encrypted_password     :string           default(""), not null
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
#  uid                    :string           default(""), not null
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

  # Associations
  # ...

  # Validations
  # ----------------------------------------------------------------------------------------
  # Remove Devise's uniqueness validator
  # and replace with our own email uniqueness validator
  # ----------------------------------------------------------------------------------------
  class_eval do
    _validators.delete(:email)

    _validate_callbacks.each do |callback|
      if callback.raw_filter.respond_to? :attributes
        callback.raw_filter.attributes.delete :email
      end
    end
  end

  validates :email, :mobile_phone, presence: true
  validates :mobile_phone, length: 9..20
  validates_uniqueness_of :email, :mobile_phone
end
