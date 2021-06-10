class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table "admins" do |t|
      t.string "provider", default: "email", null: false
      t.string "uid", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.boolean "allow_password_change", default: false
      t.datetime "remember_created_at"
      t.integer "failed_attempts", default: 0, null: false
      t.string "unlock_token"
      t.datetime "locked_at"
      t.string "name", null: false
      t.text "image_data"
      t.string "email"
      t.text "tokens"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.datetime "deleted_at"
      t.string "mobile_phone", limit: 20, null: false
      t.index ["email"], name: "index_admins_on_email", unique: true
      t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
      t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true
      t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
    end
  end
end
