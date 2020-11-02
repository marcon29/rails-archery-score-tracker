class MoveDisciplineFromArcherCatToRoundFormat < ActiveRecord::Migration[6.0]
  def change
    remove_column :organization_archer_categories, :discipline_id, :integer
    add_reference :format_round_formats, :discipline, index: true
  end
end
