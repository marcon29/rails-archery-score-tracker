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
    
    
    # ##### helpers (callbacks & validations)
    def name
        self.gender.name == "Male" ? gender = "Men" : gender = "Women" 
        "#{self.division.name}-#{self.age_class.name}-#{gender}"
    end
    
    def format_cat_code
        self.cat_code = self.cat_code.gsub(" ", "").upcase if self.cat_code
    end

    
    # ##### helpers (data control)
    def self.find_eligible_categories_by_age_gender(age: age, gender: gender)
        age_classes = Organization::AgeClass.find_eligible_age_classes_by_age(age)
        
        categories = []
        age_classes.each do |ac|
            self.where(age_class: ac).where(gender: gender).each { |cat| categories << cat }
        end
        categories
    end
    
    def self.find_category(gov_body: gov_body, division: division, age_class: age_class, gender: gender)
        Organization::ArcherCategory.where(gov_body: gov_body).where(division: division).where(age_class: age_class).where(gender: gender).first
    end
end