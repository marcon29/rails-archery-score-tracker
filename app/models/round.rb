class Round < ApplicationRecord
    has_many :rsets, dependent: :destroy
    has_many :ends, dependent: :destroy
    has_many :shots, dependent: :destroy
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round_format, class_name: "Format::RoundFormat"
    belongs_to :archer_category, class_name: "Organization::ArcherCategory"
    
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
    # validates :rank, 
    #     presence: { message: "You must enter a rank if Set/Distance complete." }, 
    #     if: :complete?
    validate :check_associations, :check_and_assign_rank
    # validates_associated :rsets
    before_validation :assign_name


    # ##### helpers (callbacks & validations)
    # auto create name ( ScoreSession.name - RoundFormat.name )
    def assign_name
        if self.score_session && self.round_format
            self.name = create_name
        end
# binding.pry # update 3    round validation
# binding.pry # new 6       round validation
    end

    def create_name
        "#{self.score_session.name} - #{self.round_format.name}" # if self.round
    end

    # ##### helpers (data control)
    def gov_body
        self.score_session.gov_body
    end
    
    def discipline
        self.round_format.discipline
    end
    
    def division
        self.archer_category.division if archer_category
    end
    
    def age_class
        self.archer_category.age_class if archer_category
    end

    def gender
        self.archer.gender
    end
    
    def find_category_by_div_age_class(division: division, age_class: age_class)
        Organization::ArcherCategory.find_category(gov_body: self.gov_body, division: division, age_class: age_class, gender: self.gender)
    end

    def num_sets
        self.round_format.num_sets
    end

    def shots_per_round
        total_shots = 0
        self.rsets.each { |rset| total_shots += rset.shots_per_rset }
        total_shots
    end
end
