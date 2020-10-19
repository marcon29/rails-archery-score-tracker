class CreateScoreSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :score_sessions do |t|
      t.string :name
      t.string :score_session_type
      t.string :city
      t.string :state
      t.string :country
      t.string :start_date
      t.string :end_date
      t.string :rank
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
