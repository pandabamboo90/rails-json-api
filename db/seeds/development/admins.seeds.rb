ActiveRecord::Base.transaction do
  p "SEEDING Admin Data - Start"
  p "------------------------------------"

  admin = Admin.find_or_initialize_by(
    email: 'admin@example.com'
  )

  if admin.new_record?
    admin.name = 'Admin'
    admin.password = 'password@'
    admin.mobile_phone = Faker::PhoneNumber.cell_phone
    admin.save!
  end

  100.times do |idx|
    admin = Admin.find_or_initialize_by(
      email: "admin#{idx + 1}@example.com"
    )

    if admin.new_record?
      admin.name = Faker::Name.name
      admin.password = 'password@'
      admin.mobile_phone = Faker::PhoneNumber.cell_phone
      admin.save!
    end
  end

  p "SEEDING Admin Data - Done"
  p "------------------------------------"
end