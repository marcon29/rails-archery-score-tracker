class Round < ApplicationRecord
    has_many :rsets
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session

    # has_one :archer_category, through: :archer
    # has_one :discipline, division, age_class, through: :archer_category

    # all attrs - :name, :round_type, :score_method, :rank
    
    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :score_session }
    validates :round_type, 
        presence: { message: "You must choose a round type." }, 
        inclusion: { in: ROUND_TYPES }
    validates :score_method, 
        presence: { message: "You must choose a score method." }, 
        inclusion: { in: SCORE_METHODS }
    validate :check_and_assign_rank
    before_validation :assign_name
    
    
    # keeping this until I'm sure the discipline association works
    # validates :discipline, 
    #     presence: { message: "You must choose a discipline." }, 
    #     inclusion: { in: DISCIPLINES }


    # callbacks/validation helpers
    
    # auto create name ( ScoreSession.name - RoundFormat.name )
    def assign_name
        if !self.name.blank? && self.score_session
            if !self.name.include?(score_session.name)
                # "#{self.score_session.name} - #{round_format.name}"

                # using name input until RoundFormat assoc
                # could work like this and have controller grab the RoundFormat name instead of via assoc
                self.name = "#{self.score_session.name} - #{self.name}"
            end
        end
    end

    # need other helper methods
        # it "can calculate the total score for a round" do
            # pending "need to add associations"
            # want to be able to to call round.score
            # sums all rset scores
        # end

        # ##########################
        # check out ArcherCategory (model and specs) for ideas and started code

        # ########### to set category by selections from setting up Round ###############
        # returns a category by division, age_class & gender
            # originally from archer_category
        # def self.default(division, age_class, gender)
            # self.where("max_age >=?", age).where("min_age <=?", age).where(cat_gender: gender, cat_division: division)
            # finds division by name (only input at Round)
            # finds age_class by name
            # finds gender by name
        # end

        


end
