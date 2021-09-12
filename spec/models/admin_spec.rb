require 'rails_helper'

RSpec.describe Admin, type: :model do
  subject { FactoryBot.build(:admin) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_presence_of(:mobile_phone) }
    it { is_expected.to validate_uniqueness_of(:mobile_phone).ignoring_case_sensitivity }
    it { is_expected.to validate_length_of(:mobile_phone).is_at_least(9).is_at_most(20) }
  end
end
