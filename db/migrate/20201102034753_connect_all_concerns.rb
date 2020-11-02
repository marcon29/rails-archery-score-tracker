class ConnectAllConcerns < ActiveRecord::Migration[6.0]
  def change
    add_reference :score_sessions, :gov_body, index: true
    add_reference :rounds, :archer_category, index: true
    add_reference :rsets, :dist_targ_cat, index: true
  end
end
