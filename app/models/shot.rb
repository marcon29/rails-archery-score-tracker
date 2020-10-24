class Shot < ApplicationRecord
    
    # need to add associations        
        # belongs_to :archer, :score_session, :round, :rset, :end
        

    # old all attrs - :archer_id, :score_session_id, :round_id, :rset_id, :end_num, :shot_num, :score, :set_score, shot_date
    # old all data attrs  - :shot_date, :end_num, :shot_num, :score_entry, :set_score

    # all assoc attrs - :archer_id, :score_session_id, :round_id, :rset_id, :end_id
    # all data attrs  - :shot_num, :score_entry


    # need validations
        # required: :date, :end_num, :shot_num, :score_entry, :set_score ( if rset.score_method == "Set" )
            
            # "You must enter a score for shot #{shot.shot_num}."
            # "You must enter a set score for the end."
        # inclusion: 
        #     :shot_num ( 1 - rset.shots_per_end ), 
        #     :score_entry ( 1 - target.max_score, M, X if target.x_ring )
        # format: :shot_num (number), :score_entry (cap, length = 1)

        # score_entry validation rules
            # must be able to be blank on instantiation
            # upon update, must be included in possible_scores
            




    # need helpers (callbacks & validations)
        # need to assign shot_num (same as end_num for End)
        # to validate score_entry
            # it "can identify all possible score values" do
            #     want to be able to to call shot.possible_scores
            #     max_score..score_areas, M, and X if x_ring
            # end

        
    # need helpers (data control)
        # it "can calculate a score (point value) for a shot" do
            # want to be able to to call shot.score
            # needs assoc: rset
            # converts score_entry into integer
                # if score_entry == "X", score = shot.target_method.max_score
                # if score_entry == "M", score = 0
                # else score = score_entry.to_i
        # end

        # it "can find the date a shot was made" do
            # want to be able to to call shot.date
            # needs assoc: rset
            # date = shot.rset.date
        # end

        # it "can find the date a shot was made" do
            # want to be able to to call shot.date
            # needs assoc: rset
            # date = shot.rset.date
        # end

        # it "can find the target into which shot was made" do
            # want to be able to to call shot.target
            # needs assoc: rset
            # target = shot.rset.target
        # end

        # it "can find the distance at which shot was made" do
            # want to be able to to call shot.date
            # needs assoc: rset
            # distance = shot.rset.distance
        # end

        # it "can find the end number shot belongs to" do
            # do I really need this - originally for calculating end score before creating model?
            # want to be able to to call shot.end_num
            # needs assoc: end
            # end_num = shot.end.number
        # end

        # it "can find the discipline in which the shot was made" do
            # want to be able to to call shot.discipline
            # needs assoc: round
            # discipline = shot.round.discipline
        # end

        # it "can find the division in which the shot was made" do
            # want to be able to to call shot.division
            # needs assoc: round
            # division = shot.round.division
        # end

        # it "can find the age class in which the shot was made" do
            # want to be able to to call shot.age_class
            # needs assoc: round
            # age_class = shot.round.age_class
        # end

        # it "can identify its archer's archer_category for the round it's in" do
            # do I really need this - purpose other than finding division, age_class?
            # want to be able to to call shot.archer_category
            # needs assoc: round, archer?
            # age_class = shot.round.archer_category
        # end
    

end
