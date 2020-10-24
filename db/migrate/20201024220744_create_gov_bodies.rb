class CreateGovBodies < ActiveRecord::Migration[6.0]
  def change
    create_table :gov_bodies do |t|
      t.string :name
      t.string :org_type
      t.string :geo_area

      t.timestamps
    end
  end
end
