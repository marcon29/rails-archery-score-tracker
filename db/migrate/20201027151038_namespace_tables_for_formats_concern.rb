class NamespaceTablesForFormatsConcern < ActiveRecord::Migration[6.0]
  def up
    rename_table :round_formats, :format_round_formats
    rename_table :set_end_formats, :format_set_end_formats
  end

  def down
    rename_table :format_round_formats, :round_formats
    rename_table :format_set_end_formats, :set_end_formats
  end
end
