class Organization::GovBody < ApplicationRecord
    has_many :disciplines_gov_bodies, class_name: "Organization::DisciplinesGovBodies"
    has_many :disciplines, through: :disciplines_gov_bodies
    has_many :archer_categories
    has_many :divisions, through: :archer_categories
    has_many :age_classes, through: :archer_categories
    has_many :genders, through: :archer_categories
    has_many :score_sessions

    # all attrs - :name, :org_type, :geo_area
    
    # Regular user can't update these - only for app to reference. Validations to ensure data integrity when extending app.
    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :org_type, 
        presence: { message: "You must choose an organization type." }, 
        inclusion: { in: ORG_TYPES }
end
