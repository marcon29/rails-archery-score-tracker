class End < ApplicationRecord
    # need to add associations
        # has_many :shots
        # has_one :archer, :score_session, :round, :rset through: :shots
        
    # all attrs - :number, :set_score


    # need validations
        # required: :number, :set_score ( if end.round.score_method == "Set" )
            # "You must enter a set score for the end."
        # inclusion: 
        #     :number ( 1 through rset.ends.count ), 
        #     :set_score ( 0 - 2 )
        # format: :number (number), :set_score (number)

        # set_score validation rules
            # must be able to be blank on instantiation
            # if end.round.score_method == "Set", can't be blank (only when updating)
            # if end.round.score_method == "Points", must be blank (just delete any entry)


    # need helpers (callbacks & validations)
    # need to auto create number ( sequential by rset )
        # SetEndFormat.name will be input by controller, not via assoc.


    # need helpers
        # need to get distance and target (same process for each)
        
        # it "can calculate the total score for a rset" do
            # pending "need to add associations"
            # want to be able to to call end.score
            # sums all shot scores
        # end

        # it "can track if end it is in is complete or not" do
            # can use this to identify the active end so only display form for that end
            # want to be able to to call shot.end_complete?
        # end


end