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

ActiveRecord::Schema.define(version: 2020_11_02_034753) do

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
    t.string "default_division"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ends", force: :cascade do |t|
    t.integer "number"
    t.integer "set_score"
    t.integer "archer_id"
    t.integer "score_session_id"
    t.integer "round_id"
    t.integer "rset_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "format_round_formats", force: :cascade do |t|
    t.string "name"
    t.integer "num_sets"
    t.integer "discipline_id"
    t.boolean "user_edit", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discipline_id"], name: "index_format_round_formats_on_discipline_id"
  end

  create_table "format_set_end_formats", force: :cascade do |t|
    t.string "name"
    t.integer "num_ends"
    t.integer "shots_per_end"
    t.integer "round_format_id"
    t.boolean "user_edit", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "format_targets", force: :cascade do |t|
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

  create_table "organization_age_classes", force: :cascade do |t|
    t.string "name"
    t.integer "min_age"
    t.integer "max_age"
    t.boolean "open_to_younger"
    t.boolean "open_to_older"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "organization_archer_categories", force: :cascade do |t|
    t.string "cat_code"
    t.integer "gov_body_id"
    t.integer "division_id"
    t.integer "age_class_id"
    t.integer "gender_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "organization_disciplines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "organization_disciplines_gov_bodies", id: false, force: :cascade do |t|
    t.integer "gov_body_id", null: false
    t.integer "discipline_id", null: false
  end

  create_table "organization_dist_targ_cats", force: :cascade do |t|
    t.integer "set_end_format_id"
    t.integer "archer_category_id"
    t.string "distance"
    t.integer "target_id"
    t.integer "alt_target_id"
    t.index ["set_end_format_id"], name: "index_organization_dist_targ_cats_on_set_end_format_id"
    t.index ["target_id"], name: "index_organization_dist_targ_cats_on_target_id"
    t.index ["alt_target_id"], name: "index_organization_dist_targ_cats_on_alt_target_id"
  end

  create_table "organization_divisions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "organization_genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "organization_gov_bodies", force: :cascade do |t|
    t.string "name"
    t.string "org_type"
    t.string "geo_area"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.string "name"
    t.string "round_type"
    t.string "score_method"
    t.string "rank"
    t.integer "archer_id"
    t.integer "score_session_id"
    t.integer "round_format_id"
    t.integer "archer_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["round_format_id"], name: "index_rounds_on_round_format_id"
    t.index ["archer_category_id"], name: "index_rounds_on_archer_category_id"
  end

  create_table "rsets", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "rank"
    t.integer "archer_id"
    t.integer "score_session_id"
    t.integer "round_id"
    t.integer "set_end_format_id"
    t.integer "distance_target_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["set_end_format_id"], name: "index_rsets_on_set_end_format_id"
    t.index ["distance_target_category_id"], name: "index_rsets_on_distance_target_category_id"
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
    t.integer "archer_id"
    t.integer "gov_body_id"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gov_body_id"], name: "index_score_sessions_on_gov_body_id"
  end

  create_table "shots", force: :cascade do |t|
    t.string "score_entry"
    t.integer "archer_id"
    t.integer "score_session_id"
    t.integer "round_id"
    t.integer "rset_id"
    t.integer "end_id"
    t.integer "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "organization_dist_targ_cats", "format_set_end_formats", column: "set_end_format_id"
  add_foreign_key "organization_dist_targ_cats", "format_targets", column: "alt_target_id"
  add_foreign_key "organization_dist_targ_cats", "format_targets", column: "target_id"
end
