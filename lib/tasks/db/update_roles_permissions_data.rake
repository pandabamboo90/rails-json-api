namespace :db do
  desc "Seed Role & Permissions data"
  task seed_roles_and_permissions: :environment do
    ActiveRecord::Base.transaction do
      p "Seed Role & Permissions Data - Start"
      p "------------------------------------"

      Rake::Task["db:seed_permissions"].invoke

      p "------------------------------------------------------------------------"
      p "Seeding all permissions to each role, *** Should update this in Admin UI later ***"
      p "------------------------------------------------------------------------"

      Role.all.map do |role|
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

  desc "Seed Permission data"
  task seed_permissions: :environment do
    ActiveRecord::Base.transaction do
      p "------------------------------------------------------------------------"
      p "Seed Permission Data - Start"
      p "------------------------------------------------------------------------"

      ActiveRecord::Base.transaction do
        Rails.application.routes.routes.map do |route|
          controller_path = route.defaults[:controller].to_s
          action_name = route.defaults[:action].to_s
          method = route.verb

          is_not_rails_actions = !(controller_path.include?("rails") || controller_path.include?("active_storage") || controller_path.include?("action_mailbox"))
          is_not_devise_actions = !(controller_path.include?("devise") || controller_path.include?("overrides"))
          is_not_admin_actions = !controller_path.include?("admin")
          is_not_api_index = !(controller_path.include?("application") && action_name.include?("index"))

          if controller_path.present? &&
            is_not_rails_actions &&
            is_not_devise_actions &&
            is_not_admin_actions &&
            is_not_api_index
            permission_record = Permission.find_or_initialize_by(
              method: method,
              controller_path: controller_path,
              action_name: action_name
            )
            permission_record.display_name = "#{method} | #{controller_path} | #{action_name}"
            permission_record.save!

            p "Created #{permission_record.display_name}"
          end
        end
      end

      p "------------------------------------------------------------------------"
      p "SEEDING Permission Data - Done"
      p "------------------------------------------------------------------------"
    end
  end
end
