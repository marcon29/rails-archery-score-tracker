class ConnectAllConcerns < ActiveRecord::Migration[6.0]
  def change
    add_reference :score_sessions, :gov_body, index: true
    add_reference :rounds, :archer_category, index: true
    add_reference :rsets, :distance_target_category, index: true
  end
end
