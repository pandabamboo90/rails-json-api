class CreateRolesPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table(:roles_permissions) do |t|
      t.references :role, foreign_key: true, index: true, null: false
      t.references :permission, foreign_key: true, index: true, null: false
    end

    add_index(:permissions, %i[method controller_path action_name], name: 'idx_1', unique: true)
    add_index(:roles_permissions, %i[role_id permission_id], unique: true)
  end
end
