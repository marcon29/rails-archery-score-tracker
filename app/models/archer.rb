class Archer < ApplicationRecord

    # need to add associations
        # has_many :shots
        # has_many :score_sessions, :rounds, :rsets, :ends, through: :shots
        # has_many :distance_target_categories
        # has_many :archer_categories, through: :distance_target_categories
        has_secure_password 

    # all authentication attrs - :username :email :password 
    # all data attrs - :first_name :last_name :birthdate :gender :home_city :home_state :home_country :default_age_class, :default_division
    @@all_age_classes = []
    
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
        inclusion: { in: GENDERS, message: "You can only choose male or female."  }
    validates :default_age_class, presence: true, inclusion: { in: @@all_age_classes }
    validates :default_division, 
        presence: { message: "You must enter your primary shooting style." }, 
        inclusion: { in: DIVISIONS }
        
    before_validation :all_age_classes, :assign_default_age_class, :format_names
    before_save :format_username, :format_email
        # format username and email after validations so spaces can be caught

        

    # #########################
    # validation helpers (already tested)

    # need to update this as you create associations
    def assign_default_age_class
        # need to update to using the associated instance???
        # possible updates in ArchCat model: instance scope (for above)?, return single object instead of array?
        if self.birthdate
            category = ArcherCategory.default("Recurve", self.eligibility_age, self.gender).first
            self.default_age_class = category.cat_age_class if category
        end
    end
    
    def all_age_classes
        AGE_CLASSES.collect do |gov, classes|
            classes.each { |c| @@all_age_classes << c }
        end
        @@all_age_classes.uniq
    end
    
    def eligibility_age
        Date.today.year-self.birthdate.year if self.birthdate
    end

    def format_names
        self.first_name = self.first_name.capitalize
        self.last_name = self.last_name.capitalize
    end

    def format_email
        self.email = self.email.downcase.gsub(" ","")
    end

    def format_username
        self.username = self.username.downcase.gsub(" ","")
    end
    
    # #########################
    # other helpers (need to add tests to helpers section tested)

    # need helpers
        # all home info
            # should be some gems to better handle this
            # city - make initial cap
            # state - all cap, two letter only
            # country - abbreviations?

    def age
        today = Date.today.strftime("%m/%d")
        birthday = self.birthdate.strftime("%m/%d")
        today >= birthday ? eligibility_age : eligibility_age-1
    end

    def full_name
        "#{self.first_name.capitalize} #{self.last_name.capitalize}"
    end

    # ##########################
    # check out ArcherCategory (model and specs) for ideas and started code

    def eligbile_categories
        # need to update to using the associated instance???
        # possible updates in ArchCat model: instance scope (for above)?
        ArcherCategory.eligible_categories_by_name(self.eligibility_age, self.gender)
    end

    def eligbile_age_classes
        # need to update to using the associated instance???
        # possible updates in ArchCat model: instance scope (for above)?
        ArcherCategory.eligible_categories_by_age_class(self.eligibility_age, self.gender)
    end
    

end
