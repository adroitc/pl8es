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

ActiveRecord::Schema.define(version: 20150508133332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "beverage_translations", force: :cascade do |t|
    t.integer  "beverage_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "beverage_translations", ["beverage_id"], name: "index_beverage_translations_on_beverage_id", using: :btree
  add_index "beverage_translations", ["locale"], name: "index_beverage_translations_on_locale", using: :btree

  create_table "beverages", force: :cascade do |t|
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "beverage_navigation_id"
    t.integer  "position"
    t.string   "amount"
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "parent_id"
    t.string   "style"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_dimensions"
    t.string   "image_fingerprint"
    t.boolean  "image_crop_processed", default: true
  end

  create_table "category_dishes", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "dish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "clients", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.string   "device_id"
    t.string   "device_app"
    t.string   "device_version"
    t.string   "device_type"
    t.string   "device_system"
    t.string   "request_hash"
    t.datetime "request_update"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",         default: true
  end

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "device_id"
    t.string   "device_app"
    t.string   "device_version"
    t.string   "device_type"
    t.string   "device_system"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dish_ingredients", force: :cascade do |t|
    t.integer  "dish_id"
    t.integer  "ingredient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dish_translations", force: :cascade do |t|
    t.integer  "dish_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.string   "drinks"
    t.string   "sides"
  end

  add_index "dish_translations", ["dish_id"], name: "index_dish_translations_on_dish_id", using: :btree
  add_index "dish_translations", ["locale"], name: "index_dish_translations_on_locale", using: :btree

  create_table "dishes", force: :cascade do |t|
    t.integer  "dishsuggestion_1_id"
    t.integer  "dishsuggestion_2_id"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_dimensions"
    t.string   "image_fingerprint"
    t.boolean  "image_crop_processed", default: true
    t.integer  "restaurant_id"
  end

  create_table "dishes_ingredients", force: :cascade do |t|
    t.integer "dish_id"
    t.integer "ingredient_id"
  end

  create_table "favorite_restaurants", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_translations", force: :cascade do |t|
    t.integer  "ingredient_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "ingredient_translations", ["ingredient_id"], name: "index_ingredient_translations_on_ingredient_id", using: :btree
  add_index "ingredient_translations", ["locale"], name: "index_ingredient_translations_on_locale", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
  end

  create_table "languages", force: :cascade do |t|
    t.string   "title"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_restaurants", force: :cascade do |t|
    t.integer "language_id"
    t.integer "restaurant_id"
  end

  create_table "locations", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string   "title"
    t.string   "from_time"
    t.string   "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
  end

  create_table "offers", force: :cascade do |t|
    t.integer  "dish_id"
    t.string   "every"
    t.text     "on"
    t.integer  "interval"
    t.date     "start_date"
    t.date     "end_date",   default: '2037-12-31'
    t.text     "except"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "offers", ["dish_id"], name: "index_offers_on_dish_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.integer  "session_id"
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_translations", force: :cascade do |t|
    t.integer  "restaurant_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "restaurant_translations", ["locale"], name: "index_restaurant_translations_on_locale", using: :btree
  add_index "restaurant_translations", ["restaurant_id"], name: "index_restaurant_translations_on_restaurant_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "telephone"
    t.string   "website"
    t.string   "download_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_language_id"
    t.integer  "default_menu_id"
    t.string   "email"
    t.string   "preview_image_file_name"
    t.string   "preview_image_content_type"
    t.integer  "preview_image_file_size"
    t.datetime "preview_image_updated_at"
    t.string   "preview_image_dimensions"
    t.string   "preview_image_fingerprint"
    t.integer  "preview_image_crop_w"
    t.integer  "preview_image_crop_h"
    t.integer  "preview_image_crop_x"
    t.integer  "preview_image_crop_y"
    t.boolean  "preview_image_crop_processed",      default: true
    t.string   "appmain_image_file_name"
    t.string   "appmain_image_content_type"
    t.integer  "appmain_image_file_size"
    t.datetime "appmain_image_updated_at"
    t.string   "appmain_image_dimensions"
    t.string   "appmain_image_fingerprint"
    t.integer  "appmain_image_crop_w"
    t.integer  "appmain_image_crop_h"
    t.integer  "appmain_image_crop_x"
    t.integer  "appmain_image_crop_y"
    t.boolean  "appmain_image_crop_processed",      default: true
    t.string   "logo_image_file_name"
    t.string   "logo_image_content_type"
    t.integer  "logo_image_file_size"
    t.datetime "logo_image_updated_at"
    t.string   "logo_image_dimensions"
    t.string   "logo_image_fingerprint"
    t.integer  "logo_image_crop_w"
    t.integer  "logo_image_crop_h"
    t.integer  "logo_image_crop_x"
    t.integer  "logo_image_crop_y"
    t.boolean  "logo_image_crop_processed",         default: true
    t.string   "splashscreen_image_file_name"
    t.string   "splashscreen_image_content_type"
    t.integer  "splashscreen_image_file_size"
    t.datetime "splashscreen_image_updated_at"
    t.string   "splashscreen_image_dimensions"
    t.string   "splashscreen_image_fingerprint"
    t.integer  "splashscreen_image_crop_w"
    t.integer  "splashscreen_image_crop_h"
    t.integer  "splashscreen_image_crop_x"
    t.integer  "splashscreen_image_crop_y"
    t.boolean  "splashscreen_image_crop_processed", default: true
    t.string   "restaurant_image_file_name"
    t.string   "restaurant_image_content_type"
    t.integer  "restaurant_image_file_size"
    t.datetime "restaurant_image_updated_at"
    t.string   "restaurant_image_dimensions"
    t.string   "restaurant_image_fingerprint"
    t.integer  "restaurant_image_crop_w"
    t.integer  "restaurant_image_crop_h"
    t.integer  "restaurant_image_crop_x"
    t.integer  "restaurant_image_crop_y"
    t.boolean  "restaurant_image_crop_processed",   default: true
    t.string   "background_type"
    t.string   "billing_contact"
    t.datetime "client_reset_date"
  end

  create_table "restaurants_tags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "restaurant_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.text     "user_agent"
  end

  create_table "tag_translations", force: :cascade do |t|
    t.integer  "tag_id",     null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
  end

  add_index "tag_translations", ["locale"], name: "index_tag_translations_on_locale", using: :btree
  add_index "tag_translations", ["tag_id"], name: "index_tag_translations_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_users", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "last_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                   default: "User"
    t.string   "product_referer"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_foreign_key "offers", "dishes"
end
