after "development:permissions" do
  ActiveRecord::Base.transaction do
    p "------------------------------------------------------------------------"
    p "Seed Role & Permissions Data - Start"
    p "------------------------------------------------------------------------"

    Rake::Task["db:seed_permissions"].invoke

    p "------------------------------------------------------------------------"
    p "Seeding all permissions to GLOBAL ROLE"
    p "------------------------------------------------------------------------"

    Role.global.map do |role|
      Permission.pluck(:id).map { |permission_id|
        RolePermission.find_or_create_by!(
          role_id: role.id,
          permission_id: permission_id
        )
      }

      p "Seeding all Permissions >>> to >>>  Role #{role.display_name}"
    end

    p "------------------------------------------------------------------------"
    p "SEEDING  Role & Permissions Data - Done"
    p "------------------------------------------------------------------------"
  end
end