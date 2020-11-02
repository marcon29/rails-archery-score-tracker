class Organization::ArcherCategory < ApplicationRecord
    belongs_to :gov_body
    belongs_to :division
    belongs_to :age_class
    belongs_to :gender
    has_many :distance_target_categories
    has_many :rounds

    # assoc attrs - :gov_body_id, :discipline_id, :division_id, :age_class_id, :gender_id
    # data attrs - :cat_code
    
    # Regular user can't update these - only for app to reference. Validations to ensure data integrity when extending app.
    validates :cat_code, 
        presence: { message: "You must provide a category code." }, 
        uniqueness: { case_sensitive: false, message: "That category code is already used." }
    before_validation :format_cat_code
    
    
    # helpers (callbacks & validations)
    def name
        self.gender.name == "Male" ? gender = "Men" : gender = "Women" 
        "#{self.division.name}-#{self.age_class.name}-#{gender}"
    end
    
    def format_cat_code
        self.cat_code = self.cat_code.gsub(" ", "").upcase if self.cat_code
    end



    # ########### need to build - WHERE? ###############
    # from Archer
        # call archer.eligible_categories
            # finds all elgibile categories by age (from archer) and gender (from archer)
        # call archer.eligible_age_classes
            # finds all elgibile age_classes by age (from archer) 
    # from Round
        # call round.archer_category
            # finds category by division (input), age_class (input), gender (from archer)
    

    # ########### to find dligibe age_classes and cateogries ###############
    # need to find a category by age/age_class, division and gender
    # similar to default below - used to find the category to assign to Rset
    # def category_from_div_age_gen
    # end
    
    # def self.default(division, age, gender)
    #     self.where("max_age >=?", age).where("min_age <=?", age).where(cat_gender: gender, cat_division: division)
    # end

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

    # def self.eligible_categories_by_name(age, gender)
    #     self.eligible_categories(age, gender).collect { |cat| cat.name }.uniq
    # end

    # added after original - similar to eligible_categories_by_age_class
    # def self.age_class_by_age(age)
    #     self.where("max_age >=?", age).where("min_age <=?", age)
    # end


end