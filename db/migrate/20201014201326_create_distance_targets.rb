class CreateDistanceTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :distance_targets do |t|
      t.string :distance
      t.integer :target_id
      t.integer :archer_category_id
      t.integer :set_id

      t.timestamps
    end
  end
end
