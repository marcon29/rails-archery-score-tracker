class End < ApplicationRecord
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :rset
        
    # all attrs - :number, :set_score
    # dependencies: Rset (for number creation), Round & ScoreSession (for Rset), Round (for set_score)

    validates :number, numericality: {only_integer: true, greater_than: 0 }
    validates :set_score, 
        numericality: { 
            only_integer: true, 
            greater_than_or_equal_to: 0, 
            less_than_or_equal_to: 2, 
            allow_nil: true, 
            allow_blank: true, 
            message: "You must enter 0, 1, or 2." },
        on: :create
    validates :set_score, 
        numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2, message: "You must enter 0, 1, or 2." },
        on: :update,
        unless: :score_method_is_points?
    before_validation :assign_number, :clear_set_score_if_points
    
    # need helpers (callbacks & validations)
    def assign_number
        if self.number.blank? && self.rset
            self.number = ends_in_set.count + 1 
        end
    end

    def ends_in_set
        self.rset.ends if self.rset
    end

    def score_method_is_points?
        self.round && self.round.score_method == "Points"
    end

    def clear_set_score_if_points
        self.set_score = nil if score_method_is_points?
    end 

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