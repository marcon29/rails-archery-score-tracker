class ChangeAllDatesToDateType < ActiveRecord::Migration[6.0]
  def up
    change_column :archers, :birthdate, :date
    change_column :score_sessions, :start_date, :date
    change_column :score_sessions, :end_date, :date
  end

  def down
    change_column :archers, :birthdate, :string
    change_column :score_sessions, :start_date, :string
    change_column :score_sessions, :end_date, :string
  end
end
