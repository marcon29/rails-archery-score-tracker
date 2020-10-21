class CreateShots < ActiveRecord::Migration[6.0]
  def change
    create_table :shots do |t|
      t.integer :archer_id
      t.integer :score_session_id
      t.integer :round_id
      t.integer :round_set_id
      t.integer :end_num
      t.integer :shot_num
      t.string :score_entry
      t.integer :set_score

      t.timestamps
    end
  end
end
