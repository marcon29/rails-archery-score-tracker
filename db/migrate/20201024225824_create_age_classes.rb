class CreateAgeClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :age_classes do |t|
      t.string :name
      t.integer :min_age
      t.integer :max_age
      t.boolean :open_to_younger
      t.boolean :open_to_older

      t.timestamps
    end
  end
end
