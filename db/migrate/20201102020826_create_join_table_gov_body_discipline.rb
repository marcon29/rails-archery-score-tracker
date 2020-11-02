class CreateJoinTableGovBodyDiscipline < ActiveRecord::Migration[6.0]
  def change
    create_join_table :gov_bodies, :disciplines do |t|
      # t.index [:gov_body_id, :discipline_id]
      # t.index [:discipline_id, :gov_body_id]
    end

    rename_table :disciplines_gov_bodies, :organization_disciplines_gov_bodies
  end
end
