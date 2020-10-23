class ChangeSetsToRset < ActiveRecord::Migration[6.0]
  def change
    rename_table :sets, :rsets
  end
end
