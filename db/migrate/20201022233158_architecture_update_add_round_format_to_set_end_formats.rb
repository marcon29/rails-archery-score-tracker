class ArchitectureUpdateAddRoundFormatToSetEndFormats < ActiveRecord::Migration[6.0]
  def up
    add_column :set_end_formats, :round_format_id, :integer
  end

  def down
    remove_column :set_end_formats, :round_format_id
  end
end
