# Next to do
    - finish building Shot model
        - see notes below

    - set up associations between Shot, Rset, Round, ScoreSession, Archer

    - find gem and set up location information
        - user home info
        - score_session location info
    
    - Architecture overhaul
        - double check Target model
            - namespace into Organization
        - update DistTargCat model for use with new ArcheryCategory
            - namespace into Organization
        - get ArcherCategory, Target, DistTargCat completely passing        
        
    
    - start building out controllers/views
        - build Session model
        - build user authentication
            - build profile page
            - build Oauth
        - build Target Management
        - build Round Management
        - build Results views (ScoreSessions show and index)

# General
    - think about shared vs. private objects - can be both in same model
        - shared are pre-loaded and not editable by user
        - private are user-generated and can be (not always) edited by user
        - Archer - all private
        - ScoreSessions - all private
        - Rounds - shared (pre-loaded) and private (user-created)
        - Roundsets - shared (pre-loaded) and private (user-created)
            - this isn't marked right now - might be able to via Round assoc
        - Shots - all private
        - Target - shared (pre-loaded) and private (user-created)
        - All elsee - shared (pre-loaded)
    - update numericality validations to be greater than 0
    
# Round Model
    - when instantiating, see if an existing one first
    - pre-loaded can't be updated (same as pre-load targets)
        - pre-loaded are only shared 
    - auto assigns name
    - when creating via ScoreSession
        - if existing (incl. preload), associates to ScoreSession
        - if new, is associated to only that user (no others can access)
            
  

# Shot model
    # it "can identify all possible score values" do
    #   # max_score..score_areas, M, and X if x_ring
    # end

    # it "will only allows score values up to the number of score areas, M and X" do
    # end

    # it "won't allow allow a score value of X if there is no x-ring" do
    # end

    # it "can calculate the total score for a roundset)" do
    # end


# Archer Model
    - need to update assign_default_age_class as you create associations

# ScoreSession Model
    - force rank as necessary if not practice?
        - only when all shots are scored? or all shots for each round (or Rset)?
    - only allow one active object at time

# Controller Helpers
    - all date formatting needs to go in here, not models
        - from ScoreSession model for start and end dates
            # def format_date(date)
            #    # date.strftime("%m/%d/%Y")
            #    # date.to_date.strftime("%m/%d/%Y")
            #    # "#{date.month}/#{date.day}/#{date.year}"
            #    # "#{date.to_date.month}/#{date.to_date.day}/#{date.to_date.year}"
            # end
        - from Archer model for birthdate
            # def assign_birthdate
            #     self.birthdate = format_date(self.birthdate) if !self.birthdate
            # end
            
            # def format_date(date_string)
            #     date_string.strftime("%m/%d/%Y") if date_string
            #     # date_string.strftime("%m/%d/%Y")
            # end
    - not sure where or if i'll need this
        - came from DistTargCat - should be a controller helper)
            # def distance_from_input(num, unit)
            #     "#{num}#{unit}"
            # end

            # it "can create a properly formatted distance from number and unit" do
            #   user_dist_targ = DistanceTargetCategory.new
            #   calc_distance = user_dist_targ.distance_from_input(70, "m")
            #   expect(calc_distance).to eq("70m")
            # end

            

# Archer Controller 
    - this is where to test attr formatting methods with actual input

# Round Controller 
    - can't allow an empty value for user_edit to be passed to model
        - i.e. no user_edit = "", must not use at all and allow DB default or explictly setting only
    - auto-generating name needs to be a controller method
        # round = Round.find_or_create_by(round_params)
        # create_sets(round)
        # def create_sets(round)
        #     count = 0
        #     round.num_roundsets.times do
        #         rset = Rset.find_or_create_by(
        #             name: "#{round.name} - Rset/Distance#{count +=1}"
        #             ends: params[:rset][:ends]
        #             shots_per_end: params[:rset][:shots_per_end]
        #             score_method: params[:rset][:score_method]
        #         )
        #     round.rsets << rset
        #     end
        # end
    - calc a set_rank ???
        - may need new model to make this work (might not be necessary)
        - could just have the rank in ScoreSession only that updates as go
    - if round_type is "Match", restrict rank options to "Win" or "Loss"
        
# ScoreSession Controller
    - for match Rsets and set scoring_method
        - first to 6 set points wins (don't need to complete all ends)
        - so when tracking shot.set_score, if 6, destroy any unshot ends for that SetRound

# Sessions Controller 
    - since Archer.default_cat will auto-update over time, need way to check if default_age_class must also update upon login
        - make auto-update part of login process/method
            - at login - check if still eligible for current default_age_class
                - if so, keep as is, if not, run the assign_default_age_class again
    - need to allow this to be changed by user via profile, but can use the same method
            - default_by_selection

# ArcherCategory Controller (will i even have a controller? - don't want to think right now)
    - need to restrict so user can't update any items from this model
    - this will have to be part of ArcherCat controller tests
    
    # let(:update_values) {
    #   {cat_code: "USA-CM60W", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master60", min_age: 60, max_age: "", cat_gender: "Female"}
    # }
    # it "won't update a pre-loaded (non-user-editable) category" do
    #   rm_category.update(update_values)
      
    #   expect(rm_category.cat_code).to eq("WA-RM")
    #   expect(rm_category.gov_body).to eq("World Archery")
    #   expect(rm_category.cat_division).to eq("Recurve")
    #   expect(rm_category.cat_age_class).to eq("Senior")
    #   expect(rm_category.min_age).to eq(nil)
    #   expect(rm_category.max_age).to eq(nil)
    #   expect(rm_category.cat_gender).to eq("Male")
    # end


# Target Controller tests
    # let(:update_values) {
    #   {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3}
    # }
    # it "won't update a pre-loaded (non-user-editable) target" do
    #   pre_load_target.update(update_values)

    #   expect(pre_load_target.name).to eq("122cm/1-spot/10-ring")
    #   expect(pre_load_target.size).to eq("122cm")
    #   expect(pre_load_target.score_areas).to eq(10)
    #   expect(pre_load_target.rings).to eq(10)
    #   expect(pre_load_target.x_ring).to eq(true)
    #   expect(pre_load_target.max_score).to eq(10)
    #   expect(pre_load_target.spots).to eq(1)
    # end


# DistanceTarget Controller ???
    - (revisit this if needed) or somewhere - if need to add ability to allow a user to create own distances, can't create a duplicate DistanceTarget record
    

# Misc Stuff To Do
    - when done - uncomment the USA in seeds and run that 
        - should be able to just run that to add an entirely new org to app
    - remove a couple commented out lines of code when done in rails_helper.rb