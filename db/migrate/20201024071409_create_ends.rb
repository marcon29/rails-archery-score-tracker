class CreateEnds < ActiveRecord::Migration[6.0]
  def change
    create_table :ends do |t|
      t.integer :number
      t.integer :set_score
    end
  end
end
