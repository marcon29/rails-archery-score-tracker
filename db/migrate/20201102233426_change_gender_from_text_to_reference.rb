class ChangeGenderFromTextToReference < ActiveRecord::Migration[6.0]
  def change
    remove_column :archers, :gender, :string
    add_reference :archers, :gender, index: true
  end
end
