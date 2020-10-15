class ArcherCategory < ApplicationRecord
     # validation notes
        # no duplicates: cat_code
        # required: cat_code, gov_body, cat_division, cat_age_class, cat_gender
        # restrict values of: gov_body, cat_division, cat_age_class, cat_gender
            # use global constants - need to add tests if doing this
        # don't need to display error messages
        # NOTE: restrict so user can't update these, only pre-loaded, but need easy to add for later app extension

    # need methods: 
        # creates a user-friendly display name (helper)
            # cat_division/cat_age_class/cat_gender = "Recurve-Senior-Men"
        
        # calculates a default category based off of division/age/gender data (helper - class method?)
            # finds the category instance that matches division, age and gender
                # division, age and gender must be passed in
            # returns the cat_code
            # this will be used by archer model to assign default_cat to archer
        

    # pre-load category list
        # World Archery
            # WA-Code    Recurve/Compound    Cadet/Junior/Senior/Master    Men/Women
            
        # USA Archer
            # USA-Code    Recurve/Compound    Bowman/Cub/Cadet/Junior/Senior/Master50/Master60/Master70    Men/Women
  

end
