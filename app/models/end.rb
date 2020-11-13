class End < ApplicationRecord
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :rset
        
    # assoc attrs - :archer_id, :score_session_id, :round_id, :rset_id
    # data attrs - :number, :set_score
    # user attrs - :set_score
    # DEPENDENCIES: 
        # Primary: Round (for set_score validation); Rset, SetEndFormat (auto-assign number) - need one SetEndFormat per Rset in same Round
        # Secondary: Archer, ScoreSession (for Round); RoundFormat (for Round and SetEndFormat)
        # Tertiary: Division, AgeClass, Gender (for Archer - non-assoc)

    validates :number, 
        numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: :allowable_ends_per_set }, 
        uniqueness: { scope: :rset }
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
    validate :check_associations
    before_validation :assign_number, :clear_set_score_if_points
    

    # ##### helpers (callbacks & validations)
    def assign_number
        if self.number.blank? && self.rset
            self.number = ends_in_set.count + 1 
        end
# binding.pry # new 9   end validation
    end

    def ends_in_set
        self.rset.ends if self.rset
    end

    def allowable_ends_per_set
        self.rset.num_ends
    end

    def score_method_is_points?
        self.round && self.round.score_method == "Points"
    end

    def clear_set_score_if_points
        self.set_score = nil if score_method_is_points?
    end 


    # ##### helpers (data control)
    def score
        self.shots.collect { |shot| shot.score }.sum
    end

    def scored_shots
        self.shots.select { |shot| shot.score_entry.present? }
    end

    def shots_per_end
        self.rset.shots_per_end
    end

    def complete?
        scored_shots.count < self.shots_per_end ? false : true
    end
end