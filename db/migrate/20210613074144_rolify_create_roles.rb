# frozen_string_literal: true

class RolifyCreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table(:roles) do |t|
      t.string :display_name, null: false
      t.string :name, null: false
      t.references :resource, polymorphic: true

      t.timestamps
    end

    create_table(:users_roles, id: false) do |t|
      t.references :user, index: true, foreign: true, null: false
      t.references :role, index: true, foreign: true, null: false
    end

    add_index(:roles, %i[name resource_type resource_id])
    add_index(:users_roles, %i[user_id role_id], unique: true)
  end
end
