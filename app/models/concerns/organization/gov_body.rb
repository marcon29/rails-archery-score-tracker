module Organization
    class GovBody < ApplicationRecord
        # add associations
        # has_many :archer_categories
        # has_many :disciplines, :divisions, :age_classes, :genders, through :archer_categories

        # all attrs - :name, :org_type, :geo_area

        # add validations
        # validates :name, 
        #     presence: { message: "You must enter a name." }, 
        #     uniqueness: { case_sensitive: false, message: "That name is already taken." }
        # validates :org_type, 
        #     presence: { message: "You must choose an organization type." }, 
        #     inclusion: { in: ORG_TYPES }
        # before_validation :format_name

        # helpers (callbacks & validations)
        # def format_name
        #     self.name = self.name.titlecase
        # end

        # def format_geo_area
        #     self.geo_area = self.geo_area.titlecase
        # end

        # helpers (data)

    end
end


