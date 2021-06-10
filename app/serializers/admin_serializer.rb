# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  deleted_at             :datetime
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  image_data             :text(65535)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  mobile_phone           :string(20)       not null
#  name                   :string(255)      not null
#  provider               :string(255)      default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  tokens                 :text(65535)
#  uid                    :string(255)      default(""), not null
#  unlock_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#  index_admins_on_uid_and_provider      (uid,provider) UNIQUE
#  index_admins_on_unlock_token          (unlock_token) UNIQUE
#

class AdminSerializer < BaseSerializer
  attributes :name, :email, :mobile_phone,
    :provider, :uid, :allow_password_change,
    :created_at, :updated_at, :deleted_at

  attribute :locked do |obj|
    obj.locked_at.present?
  end

  attribute :image do |obj|
    image_attribute(obj)
  end
end
