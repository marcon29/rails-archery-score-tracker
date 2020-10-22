class Set < ApplicationRecord
    # need to add associations
        # has_many :shots
        # has_many :ends, through: :shots
        # has_one :archer, :score_session, :round, through: :shots
        # has_one :distance_target_category, through: :archer
        # has_one :target, through: :distance_target_category
    
    # old attrs - :name, :ends, :shots_per_end, :score_method
    # all attrs - :name, :date, :rank

    validates :name, presence: true, uniqueness: true
    validates :date, presence: true#, inclusion: { in: score_session_dates }
    validates :rank, presence: true
    
    # validate :assign_dates, :check_and_assign_rank
    # before_validation :assign_name



    # ########### use this for the End class ########################
    # validates :score_method, 
    #     presence: { message: "You must choose a score method." }, 
    #     inclusion: { in: SCORE_METHODS }
    # ###############################################################

    

    # need helpers (callbacks & validations)
        # need to auto create name ( SetEndFormat.name + Round.name )
        # need to get score_session dates ( score_session_dates )
        # need to check and assign rank ( use same as in score_session ??? )

    # need helpers
        # need to get distance and target (same process for each)
            # find archer_category from Archer that matches:
                # assoc_round.discipline && assoc_round.division && assoc_round.age_class
            # look up distance and target from distance_target_category that matches found archer_category
        
        # it "can calculate the total score for a set" do
            # pending "need to add associations"
            # want to be able to to call set.score
            # sums all end scores
        # end

        
  

end
