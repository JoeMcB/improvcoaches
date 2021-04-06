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

ActiveRecord::Schema.define(version: 20161223230824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.boolean  "has_spaces"
  end

  create_table "cities_theatres", id: false, force: :cascade do |t|
    t.integer "city_id"
    t.integer "theatre_id"
  end

  add_index "cities_theatres", ["city_id", "theatre_id"], name: "index_cities_theatres_on_city_id_and_theatre_id", using: :btree
  add_index "cities_theatres", ["city_id"], name: "index_cities_theatres_on_city_id", using: :btree
  add_index "cities_theatres", ["theatre_id"], name: "index_cities_theatres_on_theatre_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experience_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiences", force: :cascade do |t|
    t.integer  "theatre_id"
    t.integer  "user_id"
    t.integer  "experience_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "experiences", ["user_id"], name: "index_experiences_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "invites", force: :cascade do |t|
    t.string   "code"
    t.integer  "owner_id"
    t.string   "recipient"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["code"], name: "index_invites_on_code", using: :btree
  add_index "invites", ["owner_id"], name: "index_invites_on_owner_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "space_images", force: :cascade do |t|
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size",    limit: 8
    t.datetime "photo_updated_at"
    t.integer  "sort_order"
  end

  create_table "spaces", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "city_id"
    t.decimal  "rating"
    t.string   "website_link"
    t.string   "yelp_link"
    t.string   "facebook_link"
    t.string   "address"
    t.string   "address_2"
    t.string   "zip"
    t.string   "real_city"
    t.string   "state"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "is_rehearsal",   default: true
    t.boolean  "is_performance", default: false
    t.string   "email"
  end

  add_index "spaces", ["slug"], name: "index_spaces_on_slug", using: :btree

  create_table "theatres", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_blocks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day"
    t.integer  "hour"
    t.integer  "minute"
    t.integer  "schedule_id"
  end

  add_index "time_blocks", ["schedule_id"], name: "index_time_blocks_on_schedule_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "is_coach"
    t.text     "bio"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img"
    t.integer  "rate"
    t.datetime "last_updated"
    t.integer  "is_admin"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size",       limit: 8
    t.datetime "avatar_updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_time"
    t.integer  "rating"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_token_expires_at"
    t.string   "provider"
    t.integer  "invite_id"
    t.string   "slug"
    t.boolean  "is_active"
    t.boolean  "is_sketch"
    t.boolean  "is_improv"
    t.integer  "city_id"
  end

  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
