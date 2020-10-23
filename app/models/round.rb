class Round < ApplicationRecord

    # need to add associations
        # has_many :shots
        # has_many :archers, :score_sessions, :rsets, through: :shots
        # has_many :archer_categories, through: :rsets
    
    # all attrs - :name, :discipline, :round_type, :num_roundsets, :user_edit

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :discipline, 
        presence: { message: "You must choose a discipline." }, 
        inclusion: { in: DISCIPLINES }
    validates :round_type, 
        presence: { message: "You must choose a round type." }, 
        inclusion: { in: ROUND_TYPES }
    validates :num_roundsets, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    before_validation :format_name
    
    # callbacks/validation helpers
    
    def format_name
        self.name = self.name.titlecase
    end

    # need other helper methods
    # it "can calculate the total score for a round" do
            # pending "need to add associations"
            # want to be able to to call shot.round_score
        # end

        


end
