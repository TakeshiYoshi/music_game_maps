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

ActiveRecord::Schema[7.0].define(version: 2022_04_13_103411) do
  create_table "about_games", charset: "utf8", force: :cascade do |t|
    t.bigint "user_review_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_about_games_on_game_id"
    t.index ["user_review_id", "game_id"], name: "index_about_games_on_user_review_id_and_game_id", unique: true
    t.index ["user_review_id"], name: "index_about_games_on_user_review_id"
  end

  create_table "authentications", charset: "utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "cities", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "companies", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_machines", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "game_id", null: false
    t.integer "count", default: 99, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_machines_on_game_id"
    t.index ["shop_id", "game_id"], name: "index_game_machines_on_shop_id_and_game_id", unique: true
    t.index ["shop_id"], name: "index_game_machines_on_shop_id"
  end

  create_table "games", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_games_on_title", unique: true
  end

  create_table "lines", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "code"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_lines_on_company_id"
  end

  create_table "playing_games", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_playing_games_on_game_id"
    t.index ["user_id", "game_id"], name: "index_playing_games_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_playing_games_on_user_id"
  end

  create_table "prefectures", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_prefectures_on_name", unique: true
  end

  create_table "shop_fix_requests", charset: "utf8mb4", force: :cascade do |t|
    t.boolean "not_exist", default: false, null: false
    t.boolean "duplicate", default: false, null: false
    t.boolean "fix_shop_info", default: false, null: false
    t.text "body"
    t.integer "status", default: 0, null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_shop_fix_requests_on_shop_id"
  end

  create_table "shop_histories", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.text "website", size: :medium
    t.string "twitter_id"
    t.json "games"
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "appearance_image"
    t.integer "status", default: 0, null: false
    t.index ["shop_id"], name: "index_shop_histories_on_shop_id"
    t.index ["user_id"], name: "index_shop_histories_on_user_id"
  end

  create_table "shop_stations", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "station_id", null: false
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "station_id"], name: "index_shop_stations_on_shop_id_and_station_id", unique: true
    t.index ["shop_id"], name: "index_shop_stations_on_shop_id"
    t.index ["station_id"], name: "index_shop_stations_on_station_id"
  end

  create_table "shops", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "twitter_id"
    t.text "address"
    t.bigint "prefecture_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "opening_hours"
    t.string "phone_number"
    t.text "website"
    t.string "photo_reference"
    t.string "place_id"
    t.decimal "lat", precision: 10, scale: 7
    t.decimal "lng", precision: 10, scale: 7
    t.string "photo_url"
    t.datetime "photo_url_update_at", precision: nil
    t.text "opening_hours_text"
    t.string "konami_name"
    t.string "sega_name"
    t.string "namco_name"
    t.string "taito_name"
    t.string "appearance_image"
    t.string "andamiro_name"
    t.string "tetote_name"
    t.string "takara_name"
    t.string "bandai_name"
    t.text "games_info"
    t.index ["city_id"], name: "index_shops_on_city_id"
    t.index ["name"], name: "index_shops_on_name", unique: true
    t.index ["prefecture_id"], name: "index_shops_on_prefecture_id"
  end

  create_table "stations", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "code"
    t.bigint "line_id", null: false
    t.integer "index_number"
    t.decimal "lat", precision: 10, scale: 7
    t.decimal "lng", precision: 10, scale: 7
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_id"], name: "index_stations_on_line_id"
    t.index ["prefecture_id"], name: "index_stations_on_prefecture_id"
  end

  create_table "user_reviews", charset: "utf8mb4", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "images"
    t.index ["shop_id"], name: "index_user_reviews_on_shop_id"
    t.index ["user_id"], name: "index_user_reviews_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.string "nickname", null: false
    t.text "description"
    t.boolean "anonymous", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at", precision: nil
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at", precision: nil
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at", precision: nil
    t.datetime "reset_password_email_sent_at", precision: nil
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "avatar"
    t.string "theme"
    t.integer "role", default: 0, null: false
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "about_games", "games"
  add_foreign_key "about_games", "user_reviews"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "game_machines", "games"
  add_foreign_key "game_machines", "shops"
  add_foreign_key "lines", "companies"
  add_foreign_key "playing_games", "games"
  add_foreign_key "playing_games", "users"
  add_foreign_key "shop_fix_requests", "shops"
  add_foreign_key "shop_histories", "shops"
  add_foreign_key "shop_histories", "users"
  add_foreign_key "shop_stations", "shops"
  add_foreign_key "shop_stations", "stations"
  add_foreign_key "shops", "cities"
  add_foreign_key "shops", "prefectures"
  add_foreign_key "stations", "lines"
  add_foreign_key "stations", "prefectures"
  add_foreign_key "user_reviews", "shops"
  add_foreign_key "user_reviews", "users"
end
