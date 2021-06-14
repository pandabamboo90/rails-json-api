after "development:admins" do
  ActiveRecord::Base.transaction do
    p "SEEDING User Data - Start"
    p "------------------------------------"

    100.times do |idx|
      user = User.find_or_initialize_by(
        email: "user#{idx + 1}@example.com"
      )

      if user.new_record?
        user.name = Faker::Name.name
        user.password = 'password@'
        user.mobile_phone = Faker::PhoneNumber.cell_phone
        user.save!
      end
    end

    p "SEEDING User Data - Done"
    p "------------------------------------"
  end
end