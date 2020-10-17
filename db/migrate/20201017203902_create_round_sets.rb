class CreateRoundSets < ActiveRecord::Migration[6.0]
  def change
    create_table :round_sets do |t|
      t.string :name
      t.integer :ends
      t.integer :shots_per_end
      t.string :score_method

      t.timestamps
    end

    change_table :distance_targets do |t|
      t.rename :set_id, :round_set_id
    end    
  end
end
