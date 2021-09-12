FactoryBot.define do
  sequence :admin_email do |n|
    "admin#{n}@example.com"
  end

  factory :admin, class: Admin do
    transient do
      admin_email { generate(:admin_email) }
    end

    email { admin_email }
    uid { admin_email }
    name { [Faker::Name.first_name, Faker::Name.last_name].join(' ') }
    mobile_phone { Faker::PhoneNumber.cell_phone }
    password { 'password@' }
  end
end
