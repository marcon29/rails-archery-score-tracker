class Shot < ApplicationRecord
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :rset
    belongs_to :end

    # all assoc attrs - :archer_id, :score_session_id, :round_id, :rset_id, :end_id
    # all data attrs  - :number, :score_entry
    
    # need validations
    validates :number, 
        numericality: {only_integer: true, greater_than: 0 }, 
        uniqueness: { scope: :end }
        # make inclusion so can't be more than # of shots per ends? (not part of tests right now)
            # need to find Set_End_format corresponding to rset
            # needs to be between 1 and Set_End_format.shots_per_end
    
    validates :score_entry, 
        format: { with: /\A\d|X|M\z/, allow_nil: true, allow_blank: true, message: "Enter only X, M or a number." }, 
        on: :create
    validates :score_entry, 
        # presence: { message: "You must enter a score for shot #{self.number}." }, 
        presence: { message: "You must enter a score." }, 
        format: { with: /\A\d|X|M|x|m\z/, message: "Enter only X, M or a number." }, 
        on: :update
        # score_entry validation rules
            # must be able to be blank on instantiation
            # upon update, must be included in possible_scores
                # possible scores: target.score_areas through target.max_score, M, X if target.x_ring )
                    # message if x-ring: "Enter only X, M or a number between #{shot.target.score_areas} and #{shot.target.max_score}."
                    # message if no x-ring: "Enter only M or a number between #{shot.target.score_areas} and #{shot.target.max_score}."
        
    before_validation :assign_number
    # before_validation :format_score_entry

    # need helpers (callbacks & validations)
    # need to assign number (same as end_num for End)
    def assign_number
        if self.number.blank? && self.end
            self.number = shots_in_end.count + 1 
        end
    end

    def shots_in_end
        self.end.shots if self.end
    end

        # to validate score_entry
            # it "can identify all possible score values" do
            #     want to be able to to call shot.possible_scores
            #     max_score..score_areas, M, and X if x_ring
            # end

            # it "knows if target on which shot was made has an x-ring" do
            #     want to be able to to call shot.target.x_ring?
            #     true if shot.target.x_ring == true, else false
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
