after "development:users" do
  ActiveRecord::Base.transaction do
    p "SEEDING Role Data - Start"
    p "------------------------------------"

    User.all.each_with_index do |user, idx|
      if idx <= 5
        user.add_role(:mod)
      else
        user.add_role(:member)
      end
    end

    p "SEEDING User Data - Done"
    p "------------------------------------"
  end
end