class ChangeBirthdateColumnInArcherToString < ActiveRecord::Migration[6.0]
  def change
    change_column :archers, :birthdate, :string
  end
end
