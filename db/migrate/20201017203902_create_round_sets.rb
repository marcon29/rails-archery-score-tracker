class CreateRoundSets < ActiveRecord::Migration[6.0]
  def change
    create_table :round_sets do |t|
      t.string :name
      t.integer :ends
      t.integer :shots_per_end
      t.string :score_method
      t.string :round_set_rank

      t.timestamps
    end
  end
end
