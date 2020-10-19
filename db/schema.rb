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

ActiveRecord::Schema.define(version: 2020_10_19_032411) do

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
  end

  create_table "distance_targets", force: :cascade do |t|
    t.string "distance"
    t.integer "target_id"
    t.integer "archer_category_id"
    t.integer "round_set_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "round_sets", force: :cascade do |t|
    t.string "name"
    t.integer "ends"
    t.integer "shots_per_end"
    t.string "score_method"
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
