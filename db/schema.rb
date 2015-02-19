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

ActiveRecord::Schema.define(version: 20150219152239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beverage_navigation_translations", force: true do |t|
    t.integer  "beverage_navigation_id", null: false
    t.string   "locale",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "beverage_navigation_translations", ["beverage_navigation_id"], name: "index_1cfc283b491f788097bd8f375227f08f4e1a832b", using: :btree
  add_index "beverage_navigation_translations", ["locale"], name: "index_beverage_navigation_translations_on_locale", using: :btree

  create_table "beverage_navigations", force: true do |t|
    t.integer  "beverage_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "beverage_pages", force: true do |t|
    t.integer  "restaurant_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_dimensions"
    t.string   "image_fingerprint"
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed", default: true
    t.integer  "position"
  end

  create_table "beverage_translations", force: true do |t|
    t.integer  "beverage_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "beverage_translations", ["beverage_id"], name: "index_beverage_translations_on_beverage_id", using: :btree
  add_index "beverage_translations", ["locale"], name: "index_beverage_translations_on_locale", using: :btree

  create_table "beverages", force: true do |t|
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "beverage_navigation_id"
    t.integer  "position"
    t.string   "amount"
  end

  create_table "categories", force: true do |t|
    t.integer  "menu_id"
    t.integer  "parent_id"
    t.integer  "level"
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
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed", default: true
  end

  create_table "category_translations", force: true do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "clients", force: true do |t|
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

  create_table "daily_dishes", force: true do |t|
    t.string   "title"
    t.string   "price"
    t.datetime "display_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_dimensions"
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed", default: true
    t.string   "image_fingerprint"
    t.integer  "position"
    t.integer  "restaurant_id"
  end

  create_table "dailycious_credits", force: true do |t|
    t.integer  "restaurant_id"
    t.integer  "payment_id"
    t.date     "usage_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dailycious_plans", force: true do |t|
    t.integer  "restaurant_id"
    t.string   "paypal_profile_id"
    t.string   "paypal_profile_status"
    t.boolean  "activated",             default: false
    t.date     "setup_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "device_id"
    t.string   "device_app"
    t.string   "device_version"
    t.string   "device_type"
    t.string   "device_system"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dish_translations", force: true do |t|
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

  create_table "dishes", force: true do |t|
    t.integer  "menu_id"
    t.integer  "category_id"
    t.integer  "wines_id"
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
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed", default: true
    t.integer  "ingredients_id"
    t.integer  "restaurant_id"
  end

  create_table "dishes_ingredients", force: true do |t|
    t.integer "dish_id"
    t.integer "ingredient_id"
  end

  create_table "favorite_restaurants", force: true do |t|
    t.integer  "device_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_translations", force: true do |t|
    t.integer  "ingredient_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "ingredient_translations", ["ingredient_id"], name: "index_ingredient_translations_on_ingredient_id", using: :btree
  add_index "ingredient_translations", ["locale"], name: "index_ingredient_translations_on_locale", using: :btree

  create_table "ingredients", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "title"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_restaurants", force: true do |t|
    t.integer "language_id"
    t.integer "restaurant_id"
  end

  create_table "locations", force: true do |t|
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

  create_table "menu_color_templates", force: true do |t|
    t.string   "background"
    t.string   "bar_background"
    t.string   "bev_background"
    t.string   "bev_background_selected"
    t.string   "bev_background_active"
    t.string   "bev_text"
    t.string   "bev_text_selected"
    t.string   "bev_text_active"
    t.string   "nav_background"
    t.string   "nav_background_selected"
    t.string   "nav_background_active"
    t.string   "nav_text"
    t.string   "nav_text_selected"
    t.string   "nav_text_active"
    t.string   "sub_background"
    t.string   "sub_background_selected"
    t.string   "sub_background_active"
    t.string   "sub_text"
    t.string   "sub_text_selected"
    t.string   "sub_text_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "preview_image_file_name"
    t.string   "preview_image_content_type"
    t.integer  "preview_image_file_size"
    t.datetime "preview_image_updated_at"
    t.text     "preview_image_dimensions"
    t.string   "preview_image_fingerprint"
    t.integer  "preview_image_crop_w"
    t.integer  "preview_image_crop_h"
    t.integer  "preview_image_crop_x"
    t.integer  "preview_image_crop_y"
    t.boolean  "preview_image_crop_processed", default: true
  end

  create_table "menu_colors", force: true do |t|
    t.string   "background"
    t.string   "bar_background"
    t.string   "bev_background"
    t.string   "bev_background_selected"
    t.string   "bev_background_active"
    t.string   "bev_text"
    t.string   "bev_text_selected"
    t.string   "bev_text_active"
    t.string   "nav_background"
    t.string   "nav_background_selected"
    t.string   "nav_background_active"
    t.string   "nav_text"
    t.string   "nav_text_selected"
    t.string   "nav_text_active"
    t.string   "sub_background"
    t.string   "sub_background_selected"
    t.string   "sub_background_active"
    t.string   "sub_text"
    t.string   "sub_text_selected"
    t.string   "sub_text_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
  end

  create_table "menus", force: true do |t|
    t.string   "title"
    t.string   "from_time"
    t.string   "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
  end

  create_table "payments", force: true do |t|
    t.integer  "user_id"
    t.integer  "dailycious_plan_id"
    t.string   "paypal_payment_id"
    t.string   "paypal_token"
    t.string   "paypal_payer_id"
    t.boolean  "recurring",                default: false
    t.integer  "quantity"
    t.decimal  "amount"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "successful",               default: false
    t.string   "invoice_pdf_file_name"
    t.string   "invoice_pdf_content_type"
    t.integer  "invoice_pdf_file_size"
    t.datetime "invoice_pdf_updated_at"
    t.string   "invoice_pdf_dimensions"
    t.string   "billing_contact"
  end

  create_table "requests", force: true do |t|
    t.integer  "session_id"
    t.string   "controller"
    t.string   "action"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_translations", force: true do |t|
    t.integer  "restaurant_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "restaurant_translations", ["locale"], name: "index_restaurant_translations_on_locale", using: :btree
  add_index "restaurant_translations", ["restaurant_id"], name: "index_restaurant_translations_on_restaurant_id", using: :btree

  create_table "restaurants", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "telephone"
    t.string   "website"
    t.string   "download_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_language_id"
    t.integer  "menuColor_id"
    t.integer  "menuColorTemplate_id"
    t.integer  "supportedFont_id"
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

  create_table "restaurants_tags", force: true do |t|
    t.integer "tag_id"
    t.integer "restaurant_id"
  end

  create_table "sessions", force: true do |t|
    t.integer  "user_id"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.text     "user_agent"
  end

  create_table "supported_fonts", force: true do |t|
    t.string   "title"
    t.string   "name_navigation"
    t.string   "size_navigation"
    t.string   "name_heading"
    t.string   "size_heading"
    t.string   "name_heading_small"
    t.string   "size_heading_small"
    t.string   "name_description"
    t.string   "size_description"
    t.string   "name_price"
    t.string   "size_price"
    t.string   "name_card_tab_title"
    t.string   "size_card_tab_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_translations", force: true do |t|
    t.integer  "tag_id",     null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "tag_translations", ["locale"], name: "index_tag_translations_on_locale", using: :btree
  add_index "tag_translations", ["tag_id"], name: "index_tag_translations_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_users", force: true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "isAdmin",         default: false
    t.string   "product_referer"
    t.string   "password_digest"
    t.string   "reset_token"
    t.datetime "reset_date"
  end

  create_table "wine_translations", force: true do |t|
    t.integer  "wine_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "type"
    t.string   "country"
    t.string   "description"
  end

  add_index "wine_translations", ["locale"], name: "index_wine_translations_on_locale", using: :btree
  add_index "wine_translations", ["wine_id"], name: "index_wine_translations_on_wine_id", using: :btree

  create_table "wines", force: true do |t|
    t.integer  "user_id"
    t.string   "year"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
