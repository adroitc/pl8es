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

ActiveRecord::Schema.define(version: 20140703080153) do

  create_table "categories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_users", force: true do |t|
    t.integer "category_id"
    t.integer "user_id"
  end

  create_table "category_translations", force: true do |t|
    t.integer  "category_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale"

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
    t.text     "image_dimensions",     limit: 255
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed",             default: true
    t.string   "image_fingerprint"
    t.integer  "user_id"
    t.integer  "position"
  end

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "device_id"
    t.string   "device_app"
    t.string   "device_version"
    t.string   "device_type"
    t.string   "device_system"
    t.string   "request_hash"
    t.datetime "request_update"
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

  add_index "dish_translations", ["dish_id"], name: "index_dish_translations_on_dish_id"
  add_index "dish_translations", ["locale"], name: "index_dish_translations_on_locale"

  create_table "dishes", force: true do |t|
    t.integer  "menu_id"
    t.integer  "navigation_id"
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
    t.text     "image_dimensions",     limit: 255
    t.string   "image_fingerprint"
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed",             default: true
    t.integer  "ingredients_id"
    t.integer  "user_id"
  end

  create_table "dishes_ingredients", force: true do |t|
    t.integer "dish_id"
    t.integer "ingredient_id"
  end

  create_table "ingredient_translations", force: true do |t|
    t.integer  "ingredient_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "ingredient_translations", ["ingredient_id"], name: "index_ingredient_translations_on_ingredient_id"
  add_index "ingredient_translations", ["locale"], name: "index_ingredient_translations_on_locale"

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

  create_table "languages_menus", force: true do |t|
    t.integer "language_id"
    t.integer "menu_id"
  end

  create_table "languages_users", force: true do |t|
    t.integer "language_id"
    t.integer "user_id"
  end

  create_table "locations", force: true do |t|
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.text     "preview_image_dimensions",   limit: 255
    t.string   "preview_image_fingerprint"
    t.integer  "preview_image_crop_w"
    t.integer  "preview_image_crop_h"
    t.integer  "preview_image_crop_x"
    t.integer  "preview_image_crop_y"
    t.boolean  "preview_image_processed",                default: true
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
    t.integer  "user_id"
  end

  create_table "menu_label_translations", force: true do |t|
    t.integer  "menu_label_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "menu_label_translations", ["locale"], name: "index_menu_label_translations_on_locale"
  add_index "menu_label_translations", ["menu_label_id"], name: "index_menu_label_translations_on_menu_label_id"

  create_table "menu_labels", force: true do |t|
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "from_time"
    t.string   "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_language_id"
  end

  create_table "navigation_translations", force: true do |t|
    t.integer  "navigation_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "navigation_translations", ["locale"], name: "index_navigation_translations_on_locale"
  add_index "navigation_translations", ["navigation_id"], name: "index_navigation_translations_on_navigation_id"

  create_table "navigations", force: true do |t|
    t.integer  "menu_id"
    t.integer  "navigation_id"
    t.integer  "level"
    t.string   "style"
    t.integer  "dishes_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "image_dimensions",     limit: 255
    t.string   "image_fingerprint"
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.boolean  "image_crop_processed",             default: true
  end

  create_table "opening_hours", force: true do |t|
    t.integer  "weekday"
    t.string   "a_from"
    t.string   "a_to"
    t.string   "b_from"
    t.string   "b_to"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "user_translations", force: true do |t|
    t.integer  "user_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "user_translations", ["locale"], name: "index_user_translations_on_locale"
  add_index "user_translations", ["user_id"], name: "index_user_translations_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "telephone"
    t.string   "website"
    t.string   "register_source"
    t.string   "menu_tariff"
    t.string   "daily_tariff"
    t.string   "download_code"
    t.datetime "last_login"
    t.integer  "default_language_id"
    t.integer  "default_menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "restaurant_image_file_name"
    t.string   "restaurant_image_content_type"
    t.integer  "restaurant_image_file_size"
    t.datetime "restaurant_image_updated_at"
    t.string   "restaurant_image_dimensions"
    t.string   "logo_image_file_name"
    t.string   "logo_image_content_type"
    t.integer  "logo_image_file_size"
    t.datetime "logo_image_updated_at"
    t.text     "logo_image_dimensions",           limit: 255
    t.string   "appmain_image_file_name"
    t.string   "appmain_image_content_type"
    t.integer  "appmain_image_file_size"
    t.datetime "appmain_image_updated_at"
    t.text     "appmain_image_dimensions",        limit: 255
    t.text     "restaurant_image_fingerprint",    limit: 255
    t.string   "logo_image_fingerprint"
    t.string   "appmain_image_fingerprint"
    t.integer  "restaurant_image_crop_w"
    t.integer  "restaurant_image_crop_h"
    t.integer  "restaurant_image_crop_x"
    t.integer  "restaurant_image_crop_y"
    t.integer  "logo_image_crop_w"
    t.integer  "logo_image_crop_h"
    t.integer  "logo_image_crop_x"
    t.integer  "logo_image_crop_y"
    t.integer  "appmain_image_crop_w"
    t.integer  "appmain_image_crop_h"
    t.integer  "appmain_image_crop_x"
    t.integer  "appmain_image_crop_y"
    t.boolean  "restaurant_image_crop_processed",             default: true
    t.boolean  "logo_image_crop_processed",                   default: true
    t.boolean  "appmain_image_crop_processed",                default: true
    t.integer  "menuColor_id"
    t.integer  "supportedFont_id"
    t.string   "splashscreen_image_file_name"
    t.string   "splashscreen_image_content_type"
    t.integer  "splashscreen_image_file_size"
    t.datetime "splashscreen_image_updated_at"
    t.text     "splashscreen_image_dimensions",   limit: 255
    t.string   "splashscreen_image_fingerprint"
    t.integer  "splashscreen_image_crop_w"
    t.integer  "splashscreen_image_crop_h"
    t.integer  "splashscreen_image_crop_x"
    t.integer  "splashscreen_image_crop_y"
    t.boolean  "splashscreen_image_processed",                default: true
    t.string   "background_type"
    t.integer  "menuColorTemplate_id"
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

  add_index "wine_translations", ["locale"], name: "index_wine_translations_on_locale"
  add_index "wine_translations", ["wine_id"], name: "index_wine_translations_on_wine_id"

  create_table "wines", force: true do |t|
    t.integer  "user_id"
    t.string   "year"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
