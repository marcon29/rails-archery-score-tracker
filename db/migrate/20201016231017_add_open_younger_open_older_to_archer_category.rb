class AddOpenYoungerOpenOlderToArcherCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :archer_categories, :open_to_younger, :boolean
    add_column :archer_categories, :open_to_older, :boolean
  end
end
