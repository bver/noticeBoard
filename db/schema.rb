# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110401195442) do

  create_table "boards", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "changes", :force => true do |t|
    t.integer  "note_id",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "meaning",    :null => false
    t.integer  "argument"
    t.text     "comment"
    t.datetime "created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "changes", ["created"], :name => "index_changes_on_created"
  add_index "changes", ["note_id"], :name => "index_changes_on_note_id"

  create_table "notes", :force => true do |t|
    t.integer  "board_id",                      :null => false
    t.integer  "user_id"
    t.string   "title",                         :null => false
    t.integer  "priority",   :default => 1,     :null => false
    t.boolean  "outcome"
    t.boolean  "working",    :default => false, :null => false
    t.boolean  "problem",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.boolean "board"
  end

  add_index "privileges", ["name"], :name => "index_privileges_on_name", :unique => true

  create_table "user_privs", :force => true do |t|
    t.integer "user_id",      :null => false
    t.integer "privilege_id", :null => false
    t.integer "board_id"
  end

  add_index "user_privs", ["board_id"], :name => "index_user_privs_on_board_id"
  add_index "user_privs", ["privilege_id"], :name => "index_user_privs_on_privilege_id"
  add_index "user_privs", ["user_id"], :name => "index_user_privs_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.boolean  "send_mails"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
