class AddActiveToRoundRsetEnd < ActiveRecord::Migration[6.0]
  def change
    add_column :rounds, :active, :boolean, default: true
    add_column :rsets, :active, :boolean, default: true
    add_column :ends, :active, :boolean, default: true
  end
end
