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
  end
end
