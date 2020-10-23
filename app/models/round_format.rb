class Round < ApplicationRecord

    # need to add associations
        # has_many :shots
        # has_many :rsets, :ends, through: :shots
        # has_one :archer, :score_session, through: :shots
        # has_one :archer_category, through: :archer
        # has_one :discipline, division, age_class, through: :archer_category
    
    # old attrs - :name, :discipline, :round_type, :num_roundsets, :user_edit

    # all attrs - :name, :round_type, :rank
    # format attrs - :name, :num_sets, :user_edit

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :round_type, 
        presence: { message: "You must choose a round type." }, 
        inclusion: { in: ROUND_TYPES }
    validates :num_roundsets, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    before_validation :format_name
    
    # keeping this until I'm sure the discipline association works
    # validates :discipline, 
    #     presence: { message: "You must choose a discipline." }, 
    #     inclusion: { in: DISCIPLINES }

    # callbacks/validation helpers
        # auto-create name (ScoreSession.name + RoundFormat.name)
    
    def format_name
        self.name = self.name.titlecase
    end

    # need other helper methods
    # it "can calculate the total score for a round" do
            # pending "need to add associations"
            # want to be able to to call round.score
            # sums all rset scores
        # end

        


end
