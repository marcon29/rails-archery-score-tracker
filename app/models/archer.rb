class Archer < ApplicationRecord
    has_many :score_sessions
    has_many :rounds
    has_many :rsets
    has_many :ends
    has_many :shots
    belongs_to :gender, class_name: "Organization::Gender"
    has_secure_password

    # all authentication attrs - :username :email :password 
    # data/user attrs - :first_name :last_name :birthdate :gender :home_city :home_state :home_country :default_age_class, :default_division
    # DEPENDENCIES: 
        # Tertiary: Division, AgeClass
    
    @@all_divisions = Organization::Division.all.collect { |obj| obj.name }
    @@all_age_classes = Organization::AgeClass.all.collect { |obj| obj.name }
    @@all_genders = Organization::Gender.all

    validates :username, 
        presence: { message: "You must provide a username." }, 
        uniqueness: { case_sensitive: false, message: "That username is already taken." }, 
        format: { with: /\A\w+\z/, message: "Username can only use letters and numbers without spaces." }
    validates :email, 
        presence: { message: "You must provide your email." }, 
        uniqueness: { case_sensitive: false, message: "That email is already taken." }, 
        format: { with: /\A\S+@\w+\.[a-zA-Z]{2,3}\z/, message: "Email doesn't look valid. Please use another." }
    validates :first_name, presence: { message: "You must provide your first name." }
    validates :last_name, presence: { message: "You must provide your last name." }
    validates :birthdate, presence: { message: "You must provide your birthdate." } 
    validates :gender, 
        presence: { message: "You must provide your gender." }, 
        inclusion: { in: @@all_genders, message: "You can only choose male or female."  }
    validates :default_age_class, presence: true, inclusion: { in: @@all_age_classes }
    validates :default_division, 
        presence: { message: "You must enter your primary shooting style." }, 
        inclusion: { in: @@all_divisions }
    before_validation :assign_default_age_class, :format_names
    before_save :format_username, :format_email
        # format username and email after validations so spaces can be caught


    # ##### helpers (callbacks & validations)
    def format_username
        self.username = self.username.downcase.gsub(" ","")
    end

    def format_email
        self.email = self.email.downcase.gsub(" ","")
    end    

    def format_names
        self.first_name = self.first_name.capitalize
        self.last_name = self.last_name.capitalize
    end

    # possible update - ability to break out or select by GovBody???
    def assign_default_age_class
        if self.default_age_class.blank? && self.birthdate
            self.default_age_class = find_default_age_class.name
        end
    end

    # returns youngest age class Archer is elibibility for
    def find_default_age_class
        # Organization::AgeClass.find_age_class_by_age(self.eligibility_age)
        self.eligible_age_classes.first
    end
      
    def eligibility_age
        Date.today.year-self.birthdate.year if self.birthdate
    end

    def eligible_age_classes
        Organization::AgeClass.find_eligible_age_classes_by_age(self.eligibility_age)
    end


    # ##### helpers (data control)
    def full_name
        "#{self.first_name.capitalize} #{self.last_name.capitalize}"
    end

    def age
        today = Date.today.strftime("%m/%d")
        birthday = self.birthdate.strftime("%m/%d")
        today >= birthday ? eligibility_age : eligibility_age-1
    end



    # if need the methods below anywhere else, should work in application_record as is (figure out how to use eligibility age)
    def eligible_categories
        Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: self.eligibility_age, gender: self.gender)
    end

    def eligible_age_class_names
        self.eligible_age_classes.collect { |ac| ac.name }.uniq
    end

    def eligible_category_names
        self.eligible_categories.collect { |cat| cat.name }.uniq
    end

    # #########################
    # need helpers
        # all home info
            # should be some gems to better handle this
            # city - make initial cap
            # state - all cap, two letter only
            # country - abbreviations?


end
