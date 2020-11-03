class Organization::Division < ApplicationRecord
    has_many :archer_categories
    has_many :gov_bodies, through: :archer_categories

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
