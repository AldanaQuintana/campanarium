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

ActiveRecord::Schema.define(version: 20150910023915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string  "source"
    t.text    "message"
    t.string  "username"
    t.string  "uuid"
    t.integer "notice_group_id"
  end

  add_index "comments", ["notice_group_id"], name: "index_comments_on_notice_group_id", using: :btree

  create_table "media", force: :cascade do |t|
    t.string   "file"
    t.integer  "media_owner_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "image"
    t.string   "media_owner_type"
  end

  add_index "media", ["media_owner_id"], name: "index_media_on_media_owner_id", using: :btree

  create_table "notice_groups", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "source"
    t.string   "url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "writed_at"
    t.integer  "notice_group_id"
    t.string   "keywords"
  end

  create_table "static_pages", force: :cascade do |t|
    t.string  "title"
    t.text    "main_content"
    t.string  "title_identifier"
    t.integer "order",            default: 0
  end

  create_table "user_oauths", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_oauths", ["user_id"], name: "index_user_oauths_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "name"
    t.boolean  "has_password",           default: true
    t.string   "type"
    t.boolean  "has_email",              default: true
    t.datetime "destroyed_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
