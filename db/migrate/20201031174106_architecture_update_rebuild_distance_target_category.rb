class ArchitectureUpdateRebuildDistanceTargetCategory < ActiveRecord::Migration[6.0]
  def up
    drop_table :distance_target_categories

    create_table :organization_dist_targ_cats do |t|
      t.references :set_end_format, foreign_key: { to_table: :format_set_end_formats }
      t.integer "archer_category_id"
      t.string "distance"
      t.references :target, foreign_key: { to_table: :format_targets }
      t.references :alt_target, foreign_key: { to_table: :format_targets }
    end
  end

  def down
    drop_table :organization_dist_targ_cats

    create_table :distance_target_categories do |t|
      t.string "distance"
      t.integer "target_id"
      t.integer "archer_category_id"
      t.integer "archer_id"
      t.timestamps
    end
  end
end

 