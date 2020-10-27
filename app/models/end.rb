class End < ApplicationRecord
    has_many :shots

    has_many :archers, through: :shots
    has_many :score_sessions, through: :shots
    has_many :rounds, through: :shots
    has_many :rsets, through: :shots
    # has_one :archer, through: :shots
    # has_one :score_session, through: :shots
    # has_one :round, through: :shots
    # has_one :rset, through: :shots





        
    # all attrs - :number, :set_score

    # need validations
        # required: :number, :set_score ( if end.round.score_method == "Set" )
            # "You must enter a set score for the end."
        # inclusion: 
        #     :number ( 1 through rset.ends.count ), 
        #     :set_score ( 0 - 2 )
        # format: :number (number), :set_score (number)

    validates :number, 
        numericality: {
            only_integer: true, 
            greater_than: 0, 
            # real code
            # less_than_or_equal_to: ends_in_set.count
            # use until assoc set
            less_than_or_equal_to: 6
        }
    validates :set_score, 
        numericality: {
            only_integer: true, 
            greater_thanor_equal_to: 0, 
            less_than_or_equal_to: 2, 
            allow_nil: true, 
            message: "You must enter 0, 1, or 2."
        }
    before_validation :assign_number
    
    # #################################################
    # need associations set up before I can really do anything
    # #################################################

    # set_score validation rules
        # must be able to be blank on instantiation
        # if end.round.score_method == "Set", can't be blank (only when updating)
        # if end.round.score_method == "Points", must be blank (just delete any entry)


    # need helpers (callbacks & validations)
    def assign_number
        self.number = ends_in_set.count + 1 if self.number.blank?
    end


    def ends_in_set
        # real code
        # self.rset.ends

        # use until assoc set
        # ["end1", "end2", "end3", "end4", "end5"]
        ["end1"]
    end

    
        
        # need to auto create number ( sequential by rset )
            # endd.name will be input by controller, not via assoc.


    # need helpers
        # need to get distance and target (same process for each)
        
        # it "can calculate the total score for a end" do
            # pending "need to add associations"
            # want to be able to to call end.score
            # sums all shot scores
        # end

        # it "can track if end it is in is complete or not" do
            # can use this to identify the active end so only display form for that end
            # want to be able to to call shot.end_complete?
        # end


end