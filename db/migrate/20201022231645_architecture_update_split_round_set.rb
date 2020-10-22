class ArchitectureUpdateSplitRoundSet < ActiveRecord::Migration[6.0]
  def change
    change_table :round_sets do |t|
      t.rename :ends, :num_ends
      t.remove :score_method
      t.boolean :user_edit, default: true
    end

    rename_table :round_sets, :set_end_formats

    create_table :sets do |t|
      t.string :name
      t.date :date
      t.string :rank

      t.timestamps
    end
  end
end
