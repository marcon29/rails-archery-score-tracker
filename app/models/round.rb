class Round < ApplicationRecord
    has_many :rsets
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round_format, class_name: "Format::RoundFormat"

    # has_one :archer_category, through: :archer
    # has_one :discipline, division, age_class, through: :archer_category
    
    # assoc attrs - :archer_id, :score_session_id, :round_format_id
    # data attrs - :name, :round_type, :score_method, :rank
    # user attrs - :round_type, :score_method, :rank
    # DEPENDENCIES: 
        # Primary: ScoreSession, RoundFormat (auto-assign name)
        # Secondary: Archer (for ScoreSession)
        # Tertiary: Division, AgeClass, Gender (for Archer - non-assoc)
    
    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :score_session }
    validates :round_type, 
        presence: { message: "You must choose a round type." }, 
        inclusion: { in: ROUND_TYPES }
    validates :score_method, 
        presence: { message: "You must choose a score method." }, 
        inclusion: { in: SCORE_METHODS }
    validate :check_associations, :check_and_assign_rank
    before_validation :assign_name
    
    
    # keeping this until I'm sure the discipline association works
    # validates :discipline, 
    #     presence: { message: "You must choose a discipline." }, 
    #     inclusion: { in: DISCIPLINES }


    # ##### helpers (callbacks & validations)
    # auto create name ( ScoreSession.name - RoundFormat.name )
    def assign_name
        if self.score_session && self.round_format
            if self.name.blank?
                self.name = create_name
            elsif !self.name.include?(self.score_session.name) || !self.name.include?(self.round_format.name)
                self.name = create_name
            end
        end
    end

    def create_name
        "#{self.score_session.name} - #{self.round_format.name}" # if self.round
    end

    # ##### helpers (data control)
    def score
        self.rsets.collect { |rset| rset.score }.sum
    end

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
