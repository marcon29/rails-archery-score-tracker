class Shot < ApplicationRecord
    
    # need to add associations        
        # belongs_to :archer, :score_session, round, :set
        

    # all attrs - :archer_id, :score_session_id, :round_id, :set_id, :end_num, :shot_num, :score, :set_score, shot_date
    # all data attrs  - :shot_date, :end_num, :shot_num, :score_entry, :set_score

    # ####### possible attrs to add ##########
    # target, distance, age_class, division, discipline
        # should be able to get all this but lots of db queries
        # use ||= or assign at instantiation ???



    # need validations
        # required: :date, :end_num, :shot_num, :score_entry, :set_score ( if set.score_method == "Set" )
            # "Date must be between #{shot.score_session.start_date} and #{shot.score_session.end_date}."
            # "You must enter a score for shot #{shot.shot_num}."
            # "You must enter a set score for the end."
        # inclusion: 
        #     :shot_date ( within score_session start and end dates, inclusive )
        #     :end_num ( 1 - set.ends ), 
        #     :shot_num ( 1 - set.shots_per_end ), 
        #     :score_entry ( 1 - target.max_score, M, X if target.x_ring )
        #     :set_score ( 0 - 2 )
        # format: :end_num (number), :shot_num (number), :score_entry (cap, length = 1)




    # need helpers (callbacks & validations)
        # to assign date (for inclusion validation)
            # it "can identify the range of valid dates" do
                # shot.score_session.start_date <= shot.shot_date <=shot.score_session.end_date
            # end

        # to assign score (for inclusion validation)
            # it "can identify all possible score values" do
            #   max_score..score_areas, M, and X if x_ring
            # end

        # to assign set_score (auto assign)
            # it "can auto-assign the set_score for all shots from same end at same time" do
                # takes it from last arrow of same end
                # so a single input will get assigned to last arrow of end
                # this will update all shots from same end with same set_score
                # won't update any shots if not last shot of end (separate test)
            # end


        
    # need helpers (data control)
        # to assign score (for getting points value from a score entry)
            # it "can calculate a point value (as score) from the score entry" do
                # this will be shot.score
                # must return an integer
                # will use the can calculate a score for X and M method below
            # end

            # it "can calculate a score for X and M" do
                # X = target.max_score, M = 0
            # end

        
    
    # need helpers (ScoreSession & Round display) - some of these should probably go in other models
        # to get and display end scores
            # it "can calculate the total score for an end" do
                # want to be able to to call shot.end_score
                # needs to find a specific end (shot.rs_end)
                # needs to find all shots that are in that end (end_shots)
                # needs to sum the scores from those shots (this method)
            # end

            # ############### should I build an end model????? ######################################

            # it "can find a specific end" do
                # want to be able to to call shot.rs_end
                # round_id, set_id, end_num
            # end

            # it "can find all shots that belong to same end" do
                # want to be able to to call shot.end_shots
            # end
            
            # it "can track if end it is in is complete or not" do
                # can use this to identify the active end so only display form for that end
                # want to be able to to call shot.end_complete?
            # end

            # #####################################################
        


    # need helpers (stats display) - do these now to make sure basic info works
        # it "can identify its distance" do
            # want to be able to to call shot.distance
        # end

        # it "can identify its target" do
            # want to be able to to call shot.target
        # end

        # it "can identify its archer's archer_category for the round it's in" do
            # want to be able to to call shot.archer_category
            # can get this through archer - shot.archer.archer_category
        # end



    # need helpers (stats display) - do these later

        # it "can identify its archer's age class for the round it's in" do
            # want to be able to to call shot.archer_age_class
            # can use to display all scores in a specific age class for when archer changes
            # can group common age classes from different gov_bodies
        # end

        # it "can identify its archer's division for the round it's in" do
            # want to be able to to call shot.archer_division
        # end

        # it "can identify its archer's discipline for the round it's in" do
            # want to be able to to call shot.archer_discipline
        # end

        # it "can identify its archer's discipline for the round it's in" do
            # want to be able to to call shot.archer_discipline
        # end

    

end
