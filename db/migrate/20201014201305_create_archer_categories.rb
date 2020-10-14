class CreateArcherCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :archer_categories do |t|
      t.string :cat_code
      t.string :gov_body
      t.integer :min_age
      t.integer :max_age
      t.string :cat_division
      t.string :cat_age_class
      t.string :cat_gender

      t.timestamps
    end
  end
end
