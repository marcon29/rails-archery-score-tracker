class Organization::AgeClass < ApplicationRecord
    has_many :archer_categories
    has_many :gov_bodies, through: :archer_categories

    # all attrs - :name, :min_age, :max_age, :open_to_younger, :open_to_older

    # Regular user can't update these - only for app to reference. Validations to ensure data integrity when extending app.
    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :min_age, :max_age, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    validates :open_to_younger, :open_to_older, 
        inclusion: { in: [true, false], message: "You must select if an open class." }
    before_validation :format_name, :assign_blank_ages


    # ##### helpers (callbacks & validations)
    def format_name
        self.name = self.name.titlecase
    end

    def assign_blank_ages
        self.min_age = 1 unless self.min_age
        self.max_age = 1000 unless self.max_age
    end


    # ##### helpers (data control)
    def self.find_age_class_by_age(age)
        self.where("max_age >=?", age).where("min_age <=?", age)
        # returns array of AgeClasses
    end

    def self.find_eligible_age_classes_by_age(age)
        age_classes = self.where("max_age >=?", age).where(open_to_younger: true)
        age_classes = self.where("min_age <=?", age).where(open_to_older: true) if age_classes.empty?
        age_classes.order(:min_age)
    end

end
