class CreateTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :targets do |t|
      t.string :name
      t.string :size
      t.integer :score_areas
      t.integer :rings
      t.boolean :x_ring
      t.integer :max_score
      t.integer :spots
      t.boolean :user_edit, default: true

      t.timestamps
    end
  end
end
