class ArchitectureUpdateRebuildArcherCategory < ActiveRecord::Migration[6.0]
  def up
    drop_table :archer_categories

    create_table :archer_categories do |t|
      t.string "cat_code"
      t.integer "gov_body_id"
      t.integer "discipline_id"
      t.integer "division_id"
      t.integer "age_class_id"
      t.integer "gender_id"

      t.timestamps
    end

  end

  def down
    drop_table :archer_categories

    create_table :archer_categories do |t|
      t.string "cat_code"
      t.string "gov_body"
      t.string "cat_division"
      t.string "cat_age_class"
      t.string "cat_gender"
      t.integer "min_age"
      t.integer "max_age"
      t.boolean "open_to_younger"
      t.boolean "open_to_older"

      t.timestamps
    end
  end
end
