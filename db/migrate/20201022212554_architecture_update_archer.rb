class ArchitectureUpdateArcher < ActiveRecord::Migration[6.0]
  def change
    add_column :archers, :default_division, :string
  end
end
