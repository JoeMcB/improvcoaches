# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_04_19_164253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "subdomain"
    t.boolean "has_spaces"
  end

  create_table "cities_theatres", id: false, force: :cascade do |t|
    t.integer "city_id"
    t.integer "theatre_id"
    t.index ["city_id", "theatre_id"], name: "index_cities_theatres_on_city_id_and_theatre_id"
    t.index ["city_id"], name: "index_cities_theatres_on_city_id"
    t.index ["theatre_id"], name: "index_cities_theatres_on_theatre_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experience_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiences", force: :cascade do |t|
    t.integer "theatre_id"
    t.integer "user_id"
    t.integer "experience_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_experiences_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.datetime "created_at"
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "invites", force: :cascade do |t|
    t.string "code"
    t.integer "owner_id"
    t.string "recipient"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_invites_on_code"
    t.index ["owner_id"], name: "index_invites_on_owner_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "space_images", force: :cascade do |t|
    t.integer "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer "sort_order"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "city_id"
    t.decimal "rating"
    t.string "website_link"
    t.string "yelp_link"
    t.string "facebook_link"
    t.string "address"
    t.string "address_2"
    t.string "zip"
    t.string "real_city"
    t.string "state"
    t.string "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.boolean "is_rehearsal", default: true
    t.boolean "is_performance", default: false
    t.string "email"
    t.index ["slug"], name: "index_spaces_on_slug"
  end

  create_table "theatres", force: :cascade do |t|
    t.string "name"
    t.integer "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_blocks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "day"
    t.integer "hour"
    t.integer "minute"
    t.integer "schedule_id"
    t.index ["schedule_id"], name: "index_time_blocks_on_schedule_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "is_coach"
    t.text "bio"
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "img"
    t.integer "rate"
    t.datetime "last_updated"
    t.integer "is_admin"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "auth_token"
    t.string "password_reset_token"
    t.datetime "password_reset_time"
    t.integer "rating"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_token_expires_at"
    t.string "provider"
    t.integer "invite_id"
    t.string "slug"
    t.boolean "is_active"
    t.boolean "is_sketch"
    t.boolean "is_improv"
    t.integer "city_id"
    t.index ["slug"], name: "index_users_on_slug"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
