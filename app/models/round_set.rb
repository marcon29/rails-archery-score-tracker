class RoundSet < ApplicationRecord
    # has_many :archers, score_sessions, rounds, through: :shots

    # all attrs - :name, :ends, :shots_per_end, :score_method

    has_many :distance_targets
    has_many :archer_categories, through: :distance_targets
    has_many :targets, through: :distance_targets

    validates :name, presence: true, uniqueness: true
    validates :ends, :shots_per_end, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    validates :score_method, 
        presence: { message: "You must choose a score method." }, 
        inclusion: { in: SCORE_METHODS }

    # before_validation :assign_name

    


    # need helpers
        # need to get date (from shots)
        # need to get distance (from shots)

        # it "can calculate the total score for a roundset" do
        #     pending "need to add associations"
        #     want to be able to to call shot.round_set_score
        # end

        
  

end
