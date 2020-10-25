module Organization
    class Gender < ApplicationRecord
        # has_many :archer_categories
        # has_many :gov_bodies, through: :archer_categories

        # all attrs - :name
        
        # validates :name, 
        #     presence: { message: "You must enter a gender." }, 
        #     uniqueness: { case_sensitive: false, message: "That gender is already used." }
        # before_validation :format_name

        # helpers (callbacks & validations)
        # def format_name
        #     self.name = self.name.titlecase
        # end

        # helpers (data)

    end
end
