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

ActiveRecord::Schema.define(:version => 20110418063204) do

  create_table "boards", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                         :null => false
    t.text     "description"
    t.boolean  "active",      :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["active"], :name => "index_boards_on_active"

  create_table "changes", :force => true do |t|
    t.integer  "note_id",  :null => false
    t.integer  "user_id",  :null => false
    t.integer  "meaning",  :null => false
    t.integer  "argument"
    t.text     "comment"
    t.datetime "created"
  end

  add_index "changes", ["created"], :name => "index_changes_on_created"
  add_index "changes", ["note_id"], :name => "index_changes_on_note_id"

  create_table "notes", :force => true do |t|
    t.integer  "board_id",                      :null => false
    t.integer  "user_id",    :default => -1,    :null => false
    t.string   "title",                         :null => false
    t.text     "content"
    t.integer  "priority",   :default => 1,     :null => false
    t.boolean  "outcome"
    t.boolean  "working",    :default => false, :null => false
    t.boolean  "problem",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["board_id"], :name => "index_notes_on_board_id"
  add_index "notes", ["outcome"], :name => "index_notes_on_outcome"
  add_index "notes", ["priority"], :name => "index_notes_on_priority"
  add_index "notes", ["problem"], :name => "index_notes_on_problem"
  add_index "notes", ["user_id"], :name => "index_notes_on_user_id"
  add_index "notes", ["working"], :name => "index_notes_on_working"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "board_id"
    t.string   "values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["board_id"], :name => "index_permissions_on_board_id"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                                  :null => false
    t.boolean  "send_mails",                          :default => true, :null => false
    t.boolean  "active",                              :default => true, :null => false
    t.string   "email",                               :default => "",   :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",   :null => false
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

  add_index "users", ["active"], :name => "index_users_on_active"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
