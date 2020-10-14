class CreateTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :targets do |t|
      t.string :size
      t.integer :score_areas
      t.boolean :x_ring
      t.integer :spots
      t.boolean :user_edit

      t.timestamps
    end
  end
end
