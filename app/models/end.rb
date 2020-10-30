class End < ApplicationRecord
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :rset
        
    # all attrs - :number, :set_score
    # dependencies: Rset (for number creation), Round & ScoreSession (for Rset), Round (for set_score)

    validates :number, 
        numericality: {only_integer: true, greater_than: 0 }, 
        uniqueness: { scope: :rset }
        # make inclusion so can't be more than # of ends per rset? (not part of tests right now)
            # need to find Set_End_format corresponding to Rset
            # needs to be between 1 and Set_End_format.num_ends
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
    

    # ##### helpers (callbacks & validations)
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

    def set_end_format
        # real code
        # self.rset.set_end_format

        # use til target assoc setup for Rset
        Format::SetEndFormat.first
    end

    def shots_per_end
        self.set_end_format.shots_per_end
    end


    # ##### helpers (data control)
    def score
        self.shots.collect { |shot| shot.score }.sum
    end

    def scored_shots
        self.shots.select { |shot| shot.score_entry.present? }
    end

    def complete?
        scored_shots.count < self.shots_per_end ? false : true
    end

    

    


    # ######### helpers to add once RoundFormat and SetEndFormat associations finished ###################
        # update number validation above - don't allow more ends than Rset/SetEndFormat num_ends
        # need to redo #set_end_format method above

        


end