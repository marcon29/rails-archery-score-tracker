class ArcherCategory < ApplicationRecord
    # need to add associations
    
    # Regular user can't update these, pre-loaded for reference by rest of app only,
    # but validations still helpful to ensure data integrity when extending app.
    # This also means there's no need to  display error messages.
    validates :cat_code, presence: true, uniqueness: true
    validates :gov_body, presence: true, inclusion: { in: GOV_BODIES }
    validates :cat_division, presence: true, inclusion: { in: DIVISIONS }
    validates :cat_age_class, presence: true, inclusion: { in: AGE_CLASSES.values.join(" ").split }
    validates :cat_gender, presence: true, inclusion: { in: GENDERS }

    before_validation :assign_blank_ages

    # allows for leaving oldest max_age and youngest min_age blank
    def assign_blank_ages
        self.min_age = 0 unless self.min_age
        self.max_age = 1000 unless self.max_age
    end
        
    # creates a user-friendly display name
    def name
        self.cat_gender == "Male" ? gender = "Men" : gender = "Women" 
        "#{self.cat_division}-#{self.cat_age_class}-#{gender}"
    end
        
    # returns array of ArcherCategory objects
    def self.default_by_archer_data(division, age, gender)
        self.where("max_age >=?", age).where("min_age <=?", age).where(cat_gender: gender, cat_division: division)
    end

    def self.default_by_selection(age, gender)
    # def self.default_by_selection(cat_code)
        # user will get list of eligible categories
        # user will get list of eligible categories
        
        # self.where(cat_code: cat_code)

        self.eligible(age, gender).uniq
    end

    # returns array of ArcherCategory objects
    def self.eligible(age, gender)
        categories = self.where("max_age >=?", age).where(open_to_younger: true).where(cat_gender: gender)
        if categories.empty? 
            categories = self.where("min_age <=?", age).where(open_to_older: true).where(cat_gender: gender)
        end
        categories.order(:min_age)
    end

    def self.default(age, gender)
        
        self.eligible(age, gender).collect { |cat| cat.cat_age_class }.uniq
    end

    # pre-load category list
        # World Archery
            # WA-Code    Recurve/Compound    Cadet/Junior/Senior/Master    Men/Women
            
        # USA Archer
            # USA-Code    Recurve/Compound    Bowman/Cub/Cadet/Junior/Senior/Master50/Master60/Master70    Men/Women
  

end
