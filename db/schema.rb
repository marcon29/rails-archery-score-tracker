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

ActiveRecord::Schema.define(version: 2020_10_24_160308) do

  create_table "archer_categories", force: :cascade do |t|
    t.string "cat_code"
    t.string "gov_body"
    t.integer "min_age"
    t.integer "max_age"
    t.string "cat_division"
    t.string "cat_age_class"
    t.string "cat_gender"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "open_to_younger"
    t.boolean "open_to_older"
  end

  create_table "archers", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "gender"
    t.string "home_city"
    t.string "home_state"
    t.string "home_country"
    t.string "default_age_class"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "default_division"
  end

  create_table "distance_target_categories", force: :cascade do |t|
    t.string "distance"
    t.integer "target_id"
    t.integer "archer_category_id"
    t.integer "archer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ends", force: :cascade do |t|
    t.integer "number"
    t.integer "set_score"
  end

  create_table "round_formats", force: :cascade do |t|
    t.string "name"
    t.integer "num_sets"
    t.boolean "user_edit", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.string "name"
    t.string "round_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "rank"
    t.string "score_method"
  end

  create_table "rsets", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "score_sessions", force: :cascade do |t|
    t.string "name"
    t.string "score_session_type"
    t.string "city"
    t.string "state"
    t.string "country"
    t.date "start_date"
    t.date "end_date"
    t.string "rank"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "set_end_formats", force: :cascade do |t|
    t.string "name"
    t.integer "num_ends"
    t.integer "shots_per_end"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "user_edit", default: true
    t.integer "round_format_id"
  end

  create_table "shots", force: :cascade do |t|
    t.integer "archer_id"
    t.integer "score_session_id"
    t.integer "round_id"
    t.integer "rset_id"
    t.integer "end_id"
    t.integer "number"
    t.string "score_entry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "targets", force: :cascade do |t|
    t.string "name"
    t.string "size"
    t.integer "score_areas"
    t.integer "rings"
    t.boolean "x_ring"
    t.integer "max_score"
    t.integer "spots"
    t.boolean "user_edit", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
