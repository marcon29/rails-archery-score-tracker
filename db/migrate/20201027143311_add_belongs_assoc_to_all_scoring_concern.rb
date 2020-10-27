class AddBelongsAssocToAllScoringConcern < ActiveRecord::Migration[6.0]
  def change
    add_column :score_sessions, :archer_id, :integer

    add_column :rounds, :archer_id, :integer
    add_column :rounds, :score_session_id, :integer

    add_column :rsets, :archer_id, :integer
    add_column :rsets, :score_session_id, :integer
    add_column :rsets, :round_id, :integer

    add_column :ends, :archer_id, :integer
    add_column :ends, :score_session_id, :integer
    add_column :ends, :round_id, :integer
    add_column :ends, :rset_id, :integer
  end
end
