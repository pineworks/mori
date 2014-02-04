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

ActiveRecord::Schema.define(version: 20140204044714) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "mori_users", force: true do |t|
    t.string   "email"
    t.text     "password"
    t.string   "invitation_token"
    t.datetime "invitation_sent"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent"
    t.boolean  "confirmed"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent"
    t.integer  "group_id"
    t.hstore   "data",                 default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mori_users", ["email"], name: "index_mori_users_on_email", using: :btree
  add_index "mori_users", ["group_id"], name: "index_mori_users_on_group_id", using: :btree

end
