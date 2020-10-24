class ArchitectureUpdateShot < ActiveRecord::Migration[6.0]
  def up
    change_table :shots do |t|
      t.rename :round_set_id, :rset_id
      t.rename :shot_num, :number
      t.remove :set_score
    end
  end

  def down
    change_table :shots do |t|
      t.rename :rset_id, :round_set_id
      t.rename :number, :shot_num
      t.integer :set_score
    end
  end
end
