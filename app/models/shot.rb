class Shot < ApplicationRecord
    
    # need to add associations        
        # belongs_to :archer, :score_session, round, :round_set
        # has_one :archer_category, through: :round_set

    # all attrs - :archer_id, :score_session_id, :round_id, :round_set_id, :end_num, :shot_num, :score, :set_score
    # all data attrs  - :end_num, :shot_num, :score_entry, :set_score

    # ####### possible attrs to add ##########
    # target, distance, age_class, division, discipline
        # should be able to get all this but lots of db queries
        # use ||= or assign at instantiation ???



    # need validations
        # required: :end_num, :shot_num, :score_entry, :set_score
        # inclusion: 
        #     :end_num ( 1 - round_set.ends ), 
        #     :shot_num ( 1 - round_set.shots_per_end ), 
        #     :score_entry (1 - target.max_score, M, X if target.x_ring )
        #     :set_score (0 - 2, M, X if target.x_ring )
        # format: :end_num (number), :shot_num (number), :score_entry (cap, length = 1), :set_score (cap, length = 1)




    # need helpers (callbacks & validations)
        # it "can identify all possible score values" do
        #   max_score..score_areas, M, and X if x_ring
        # end

        # it "will only allows score values up to the number of score areas, M and X" do
        # end

        # it "won't allow allow a score value of X if there is no x-ring" do
        # end

        # it "can calculate a point value (as score) from the score entry" do
            # this will be shot.score
        # end

        # it "can auto-assign the set_score for all shots from same end at same time" do
            # takes it from last arrow of same end
            # so a single input will get assigned to last arrow of end
            # this will update all shots from same end with same set_score
        # end


        
    # need helpers (data control)
        # it "can calculate a score for X and M" do
            # X = target.max_score, M = 0
        # end

        # it "can calculate a score for X and M" do
            # X = target.max_score, M = 0
        # end
               

        
    
    # need helpers (ScoreSession & Round display) - some of these should probably go in other models
        # it "can calculate the total score for an end" do
        # end

        # it "can track the set score for the end if set score method" do
            # may need another attr
        # end
        
        # it "can calculate the total score for a roundset" do
        # end

        # it "can calculate the total score for a round" do
        # end

        # it "can calculate the total score for a score session" do
        # end

        # it "can track if end it is in is complete or not" do
            # can use this to identify the active end so only display form for that end
        # end

        



    # need helpers (stats display) - do these now to make sure basic info works
        # it "can identify its target" do
            # want to be able to to call shot.target
        # end

        # it "can identify its distance" do
            # want to be able to to call shot.distance
        # end

        # it "can identify date it was shot" do
            # want to be able to to call shot.archer_category
        # end

        # it "can identify its archer's archer_category for the round it's in" do
            # want to be able to to call shot.archer_category
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
