# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131120151131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "time_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "work_unit_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "duration"
    t.text     "comment"
  end

  add_index "time_entries", ["user_id"], name: "index_time_entries_on_user_id", using: :btree
  add_index "time_entries", ["work_unit_id"], name: "index_time_entries_on_work_unit_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "work_units", force: true do |t|
    t.string   "wuid"
    t.string   "name"
    t.string   "ancestry"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_units", ["ancestry"], name: "index_work_units_on_ancestry", using: :btree

end
