class Archer < ApplicationRecord

    # need to add associations
        # has_many :shots
        # has_many :score_sessions, :rounds, :round_sets, through: :shots
        # has_many :archer_categories, through: :round_sets
        # has_secure_password 
            

    # all attrs:
        # :username :email :password :first_name :last_name :birthdate :gender :home_city :home_state :home_country :default_cat


    # need to add validations
        # required: :username :email :first_name :last_name :birthdate :gender :default_cat
        # uniqueness: :username :email
        # formatting: :username :email :password        
        # restricted values: :gender (GENDERS) :default_cat (from DB & archer category model)
        # callbacks: 
            # assign_default_category
            # format methods: username?, email, names, home_city, home_state, home_country


    # need helpers        
        # need to create full name ("First Name" + "Last Name")
            # examples from Target model
                # def create_name
                #     "#{self.size}/#{self.spots}-spot/#{self.rings}-ring"
                # end
        
        # use ArcherCategory.default(division, age, gender) to set default_cat attr via callback
            # requires an age calculation from Bday
            # since this will auto-update over time, need way to check if default_cat must also update upon login
            # need to assign auto-created name to object
            # examples from Target model
                # def assign_name
                #     self.name = create_name
                # end
            # need to allow this to be changed by user via profile, but can use the same method
                # to restrict available options for the user, use the following methods:
                    # ArcherCategory.eligible_categories(age, gender)
                    # ArcherCategory.eligible_categories_by_age_class(age, gender)
                    # ArcherCategory.eligible_categories_by_name(age, gender)
        
        # need several format methods: username?, email, names, home_city, home_state, home_country

end
