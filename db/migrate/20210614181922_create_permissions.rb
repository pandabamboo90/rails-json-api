class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.string :display_name, null: false
      t.text :description
      t.string :method, null: false
      t.string :controller_path, null: false
      t.string :action_name, null: false

      t.timestamps
    end

    create_table(:roles_permissions, id: false) do |t|
      t.references :role
      t.references :permission
    end

    add_index(:permissions, %i[method controller_path action_name], name: 'idx_1', unique: true)
    add_index(:roles_permissions, %i[role_id permission_id], unique: true)
  end
end
