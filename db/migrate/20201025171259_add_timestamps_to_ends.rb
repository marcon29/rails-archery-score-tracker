class AddTimestampsToEnds < ActiveRecord::Migration[6.0]
  def change
    change_table :ends do |t|
      t.timestamps
    end
  end
end
