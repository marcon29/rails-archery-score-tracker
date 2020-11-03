class Organization::Discipline < ApplicationRecord
    has_many :disciplines_gov_bodies, class_name: "Organization::DisciplinesGovBodies"
    has_many :gov_bodies, through: :disciplines_gov_bodies
    has_many :round_formats, class_name: "Format::RoundFormat"

    # all attrs - :name
    
    # Regular user can't update these - only for app to reference. Validations to ensure data integrity when extending app.
    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    before_validation :format_name

    # ##### helpers (callbacks & validations)
    def format_name
        self.name = self.name.titlecase
    end
end
