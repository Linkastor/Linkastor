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

ActiveRecord::Schema.define(version: 20150622082728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentication_providers", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "secret",     null: false
  end

  add_index "authentication_providers", ["uid"], name: "index_authentication_providers_on_uid", unique: true, using: :btree
  add_index "authentication_providers", ["user_id"], name: "index_authentication_providers_on_user_id", using: :btree

  create_table "custom_sources", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "type",       null: false
    t.jsonb    "extra",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_sources_users", id: false, force: :cascade do |t|
    t.integer "user_id",          null: false
    t.integer "custom_source_id", null: false
  end

  add_index "custom_sources_users", ["user_id", "custom_source_id"], name: "index_custom_sources_users_on_user_id_and_custom_source_id", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "referrer_id",                 null: false
    t.string   "email",                       null: false
    t.string   "code",                        null: false
    t.string   "group_id",                    null: false
    t.boolean  "accepted",    default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "invites", ["code"], name: "index_invites_on_code", using: :btree
  add_index "invites", ["referrer_id", "email"], name: "index_invites_on_referrer_id_and_email", unique: true, using: :btree

  create_table "links", force: :cascade do |t|
    t.integer  "group_id",                   null: false
    t.string   "url",                        null: false
    t.string   "title",                      null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "posted",     default: false, null: false
    t.datetime "posted_at"
    t.integer  "posted_by",                  null: false
  end

  add_index "links", ["group_id"], name: "index_links_on_group_id", using: :btree
  add_index "links", ["url", "created_at"], name: "index_links_on_url_and_created_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nickname"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
