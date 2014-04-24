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

ActiveRecord::Schema.define(version: 20140424105737) do

  create_table "categories", force: true do |t|
    t.integer  "menu_id"
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

  create_table "dish_translations", force: true do |t|
    t.integer  "dish_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "drinks"
    t.string   "sidedish"
    t.string   "ingredients"
  end

  add_index "dish_translations", ["dish_id"], name: "index_dish_translations_on_dish_id"
  add_index "dish_translations", ["locale"], name: "index_dish_translations_on_locale"

  create_table "dishes", force: true do |t|
    t.integer  "user_id"
    t.integer  "navigation_id"
    t.integer  "wines_id"
    t.integer  "dishes_id"
    t.string   "price"
    t.boolean  "is_daily",             default: false
    t.date     "daily_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
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

  create_table "menu_colors", force: true do |t|
    t.string   "background"
    t.string   "bar_background"
    t.string   "bev_background_selected"
    t.string   "bev_text"
    t.string   "bev_text_active"
    t.string   "bev_background"
    t.string   "bev_background_active"
    t.string   "bev_text_selected"
    t.string   "nav_background"
    t.string   "nav_background_active"
    t.string   "nav_background_selected"
    t.string   "nav_text"
    t.string   "nav_text_active"
    t.string   "nav_text_selected"
    t.string   "sub_background"
    t.string   "sub_background_active"
    t.string   "sub_background_selected"
    t.string   "sub_text"
    t.string   "sub_text_active"
    t.string   "sub_text_selected"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "menuLabel_id"
    t.integer  "navigations_id"
    t.integer  "beverages_id"
    t.integer  "languages_id"
    t.integer  "default_language_id"
    t.integer  "menuColor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "sub_navigations_id"
    t.integer  "dishes_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
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
    t.string   "address"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "telephone"
    t.string   "website"
    t.string   "register_source"
    t.string   "menu_tariff"
    t.string   "daily_tariff"
    t.string   "download_code"
    t.date     "last_login"
    t.integer  "languages_id"
    t.integer  "default_language_id"
    t.integer  "openingHours_id"
    t.integer  "categories_id"
    t.integer  "default_menu_id"
    t.integer  "menus_id"
    t.integer  "daily_dishes_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
