class NamespaceTablesForFormatsConcern < ActiveRecord::Migration[6.0]
  def up
    rename_table :round_formats, :formats_round_formats
    rename_table :set_end_formats, :formats_set_end_formats
  end

  def down
    rename_table :formats_round_formats, :round_formats
    rename_table :formats_set_end_formats, :set_end_formats
  end
end
