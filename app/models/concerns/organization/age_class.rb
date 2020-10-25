module Organization
    class AgeClass < ApplicationRecord
        has_many :archer_categories
        has_many :gov_bodies, through: :archer_categories

        # all attrs - :name, :min_age, :max_age, :open_to_younger, :open_to_older

        validates :name, 
            presence: { message: "You must enter a name." }, 
            uniqueness: { case_sensitive: false, message: "That name is already taken." }
        validates :min_age, :max_age, 
            numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
        validates :open_to_younger, :open_to_older, 
            inclusion: { in: [true, false], message: "You must select if an open class." }
        before_validation :format_name, :assign_blank_ages

        # helpers (callbacks & validations)
        def format_name
            self.name = self.name.titlecase
        end

        def assign_blank_ages
            self.min_age = 1 unless self.min_age
            self.max_age = 1000 unless self.max_age
        end
        
        # helpers (data)
        # from original archer_category - modify for only age class
        # def self.eligible_categories(age, gender)
        #     categories = self.where("max_age >=?", age).where(open_to_younger: true).where(cat_gender: gender)
        #     if categories.empty? 
        #         categories = self.where("min_age <=?", age).where(open_to_older: true).where(cat_gender: gender)
        #     end
        #     categories.order(:min_age)
        # end
    
        # def self.eligible_categories_by_age_class(age, gender)
        #     self.eligible_categories(age, gender).collect { |cat| cat.cat_age_class }.uniq
        # end

    end
end
