class Shot < ApplicationRecord
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :rset
    belongs_to :end

    # assoc attrs - :archer_id, :score_session_id, :round_id, :rset_id, :end_id
    # data attrs  - :number, :score_entry
    # user attrs - :score_entry
    # DEPENDENCIES: 
        # Primary: Target (via Rset for score_entry validation); Rset, End, SetEndFormat (auto-assign number) - need one SetEndFormat per Rset in same Round
        # Secondary: Archer, ScoreSession, Round (for Rset); RoundFormat (for Round and SetEndFormat)
        # Tertiary: Division, AgeClass, Gender (for Archer - non-assoc)
    
    validates :number, 
        numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: :allowable_shots_per_end }, 
        uniqueness: { scope: :end }
    validates :score_entry, 
        inclusion: { in: :possible_scores, allow_blank: true, message: -> (shot, data) {"#{shot.score_entry_error_message}"} }, 
        on: :create
    validates :score_entry, 
        presence: { message: -> (shot, data) {"You must enter a score for shot #{shot.number}."} }, 
        inclusion: { in: :possible_scores, message: -> (shot, data) {"#{shot.score_entry_error_message}"} }, 
        on: :update
    validate :check_associations
    before_validation :assign_number, :format_score_entry
    

    # ##### helpers (callbacks & validations)
    # assigns number (same as number for End)
    def assign_number
        if self.number.blank? && self.end
            self.number = shots_in_end.count + 1 
        end
    end

    def shots_in_end
        self.end.shots if self.end
    end

    def allowable_shots_per_end
        self.rset.shots_per_end
    end

    def possible_scores
        self.target.possible_scores
        # returns array
    end

    def score_entry_error_message
        max_score = self.target.max_score
        min_score = self.target.max_score - self.target.score_areas + 1

        "Enter only M#{', X,' if self.target.x_ring} or a number between #{min_score} and #{max_score}."
    end

    def format_score_entry
        self.score_entry = self.score_entry.capitalize if self.score_entry
    end
    
    
    # ##### helpers (data control)
    def score
        if score_entry == "X"
            self.target.max_score 
        elsif score_entry == "M"
            0 
        else
            score_entry.to_i
        end
    end

    def date
        self.rset.date
    end

    def distance
        self.rset.distance
    end

    def target
        self.rset.target
    end
        

    # ######### helpers to add once DistanceTarget and associations finished ###################

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

        # it "can find its archer's archer_category for the round it's in" do
            # do I really need this - purpose other than finding division, age_class?
            # want to be able to to call shot.archer_category
            # needs assoc: round, archer?
            # age_class = shot.round.archer_category
        # end
    
    
    

end
