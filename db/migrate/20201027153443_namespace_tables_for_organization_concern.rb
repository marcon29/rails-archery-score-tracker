class NamespaceTablesForOrganizationConcern < ActiveRecord::Migration[6.0]
  def up
    rename_table :age_classes, :organization_age_classes
    rename_table :archer_categories, :organization_archer_categories
    rename_table :disciplines, :organization_disciplines
    rename_table :divisions, :organization_divisions
    rename_table :genders, :organization_genders
    rename_table :gov_bodies, :organization_gov_bodies
  end

  def down
    rename_table :organization_age_classes, :age_classes
    rename_table :organization_archer_categories, :archer_categories
    rename_table :organization_disciplines, :disciplines
    rename_table :organization_divisions, :divisions
    rename_table :organization_genders, :genders
    rename_table :organization_gov_bodies, :gov_bodies
  end
end
