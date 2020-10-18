class Archer < ApplicationRecord

    # need to add associations
        # has_many :shots
        # has_many :score_sessions, :rounds, :round_sets, through: :shots
        # has_many :archer_categories, through: :round_sets
        has_secure_password 

    # all attrs  -  :username :email :password :first_name :last_name :birthdate :gender :home_city :home_state :home_country :default_age_class
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
    before_validation :all_age_classes, :format_birthdate, :assign_default_age_class, :format_names

    # #########################
    # validation helpers (already tested)

    # need to update this as you create associations
    def assign_default_age_class
        # need to update to using the associated instance???
        # possible updates in ArchCat model: instance scope (for above)?, return single object instead of array?
        category = ArcherCategory.default("Recurve", self.eligibility_age, self.gender).first
        self.default_age_class = category.cat_age_class if category
    end

    def all_age_classes
        AGE_CLASSES.collect do |gov, classes|
            classes.each { |c| @@all_age_classes << c }
        end
        @@all_age_classes.uniq
    end

    def format_birthdate
        self.birthdate = self.birthdate.strftime("%m/%d/%Y") if self.birthdate
    end

    def eligibility_age
        if self.birthdate
            year_today = Date.today.strftime("%Y").to_i
            birthyear = self.birthdate.strftime("%Y").to_i
            year_today-birthyear
        end
    end

    def format_names
        self.first_name = self.first_name.capitalize # if self.first_name
        self.last_name = self.last_name.capitalize # if self.last_name
    end

    # #########################
    # other helpers (need to add tests to helpers section tested)

    # need helpers
        # need several format methods: 
            # username (use as callback for keeping data cleaner)
                # make all lowercase, remove spaces
            # email (use as callback for keeping data cleaner)
                # make all lowercase, remove spaces
            
            # all home info
                # should be some gems to better handle this
                # city - make initial cap
                # state - all cap, two letter only
                # country - abbreviations?

    def age
        day_today = Date.today.strftime("%m/%d")
        year_today = Date.today.strftime("%Y").to_i

        birthday = self.birthdate.strftime("%m/%d")
        birthyear = self.birthdate.strftime("%Y").to_i

        if day_today >= birthday
            year_today-birthyear 
        else
            year_today-birthyear-1
        end
    end

    def full_name
        "#{self.first_name.capitalize} #{self.last_name.capitalize}"
    end

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
