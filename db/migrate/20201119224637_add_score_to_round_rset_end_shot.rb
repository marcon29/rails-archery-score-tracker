class AddScoreToRoundRsetEndShot < ActiveRecord::Migration[6.0]
  def change
    add_column :rounds, :score, :integer, default: 0
    add_column :rsets, :score, :integer, default: 0
    add_column :ends, :score, :integer, default: 0
    add_column :shots, :score, :integer, default: 0
  end
end
