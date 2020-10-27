class Round < ApplicationRecord
    # has_many :shots
    # has_many :rsets, through: :shots
    # has_many :ends, through: :shots
    # has_many :archers, through: :shots
    # has_many :score_sessions, through: :shots
    
    has_many :rsets
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session



    # has_one :archer_category, through: :archer
    # has_one :discipline, division, age_class, through: :archer_category

    # all attrs - :name, :round_type, :score_method, :rank
    # format attrs - :name, :num_sets, :user_edit

    # validates :name, 
    #     presence: { message: "You must enter a name." }, 
    #     uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :name, presence: true, uniqueness: true
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
    
    # need to auto create name ( ScoreSession.name - RoundFormat.name )
        # RoundFormat.name will be input by controller, not via assoc.
        def assign_name
            # can't use an arg
            # self.name = create_name
            
            # using this until associations and controller set up
            self.name = create_name("1440 Round") if self.name.blank?
        end
    
        def create_name(input)
            # "#{self.round.name} - #{input}"
    
            # using this until associations and controller set up
            temp = "100th US Nationals"
            "#{temp} - #{input}"
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
