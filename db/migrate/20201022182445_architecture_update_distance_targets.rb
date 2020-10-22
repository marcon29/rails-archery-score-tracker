class ArchitectureUpdateDistanceTargets < ActiveRecord::Migration[6.0]
  def change
    change_table :distance_targets do |t|
      t.rename :round_set_id, :archer_id
    end

    rename_table :distance_targets, :distance_target_categories
  end
end
