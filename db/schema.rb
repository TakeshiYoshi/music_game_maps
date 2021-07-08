# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_07_184235) do

  create_table "about_games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_review_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_about_games_on_game_id"
    t.index ["user_review_id", "game_id"], name: "index_about_games_on_user_review_id_and_game_id", unique: true
    t.index ["user_review_id"], name: "index_about_games_on_user_review_id"
  end

  create_table "cities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "prefecture_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "game_machines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "game_id", null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_game_machines_on_game_id"
    t.index ["shop_id", "game_id"], name: "index_game_machines_on_shop_id_and_game_id", unique: true
    t.index ["shop_id"], name: "index_game_machines_on_shop_id"
  end

  create_table "games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_games_on_title", unique: true
  end

  create_table "playing_games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_playing_games_on_game_id"
    t.index ["user_id", "game_id"], name: "index_playing_games_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_playing_games_on_user_id"
  end

  create_table "prefectures", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_prefectures_on_name", unique: true
  end

  create_table "shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "twitter_id"
    t.text "address"
    t.bigint "prefecture_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lat"
    t.string "lng"
    t.text "opening_hours"
    t.string "phone_number"
    t.text "website"
    t.string "photo_reference"
    t.string "place_id"
    t.index ["city_id"], name: "index_shops_on_city_id"
    t.index ["name"], name: "index_shops_on_name", unique: true
    t.index ["prefecture_id"], name: "index_shops_on_prefecture_id"
  end

  create_table "user_reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_user_reviews_on_shop_id"
    t.index ["user_id"], name: "index_user_reviews_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "nickname", null: false
    t.text "description"
    t.boolean "anonymous", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "about_games", "games"
  add_foreign_key "about_games", "user_reviews"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "game_machines", "games"
  add_foreign_key "game_machines", "shops"
  add_foreign_key "playing_games", "games"
  add_foreign_key "playing_games", "users"
  add_foreign_key "shops", "cities"
  add_foreign_key "shops", "prefectures"
  add_foreign_key "user_reviews", "shops"
  add_foreign_key "user_reviews", "users"
end
