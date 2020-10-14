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

ActiveRecord::Schema.define(version: 2020_10_14_201326) do

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
  end

  create_table "distance_targets", force: :cascade do |t|
    t.string "distance"
    t.integer "target_id"
    t.integer "archery_category_id"
    t.integer "set_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "targets", force: :cascade do |t|
    t.string "size"
    t.integer "score_areas"
    t.boolean "x_ring"
    t.integer "spots"
    t.boolean "user_edit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
