class NamespaceTargetForFormatConcern < ActiveRecord::Migration[6.0]
  def up
    rename_table :targets, :format_targets
  end

  def down
    rename_table :format_targets, :targets
  end
end
