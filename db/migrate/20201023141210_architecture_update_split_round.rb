class ArchitectureUpdateSplitRound < ActiveRecord::Migration[6.0]
  def up
    change_table :rounds do |t|
      t.remove :discipline
      t.remove :num_roundsets
      t.remove :user_edit
      t.string :rank
      t.string :score_method
    end

    create_table :round_formats do |t|
      t.string :name
      t.integer :num_sets
      t.boolean "user_edit", default: true

      t.timestamps
    end
  end

  def down
    change_table :rounds do |t|
      t.string :discipline
      t.integer :num_roundsets
      t.boolean "user_edit", default: true
      t.remove :rank
      t.remove :score_method
    end

    drop_table :round_formats
  end
end
