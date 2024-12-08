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

ActiveRecord::Schema[8.0].define(version: 2024_12_03_053449) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_users_on_game_id"
    t.index ["user_id"], name: "index_game_users_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "app_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "image"
    t.index ["app_uid"], name: "index_games_on_app_uid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "steam_uid"
    t.string "avatar_url"
    t.index ["steam_uid"], name: "index_users_on_steam_uid", unique: true
  end

  add_foreign_key "game_users", "games"
  add_foreign_key "game_users", "users"
end
