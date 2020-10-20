class CreateRounds < ActiveRecord::Migration[6.0]
  def change
    create_table :rounds do |t|
      t.string :name
      t.string :discipline
      t.string :round_type
      t.integer :num_roundsets
      t.boolean :user_edit, default: true

      t.timestamps
    end
  end
end
