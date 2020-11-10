class Round < ApplicationRecord
    has_many :rsets
    has_many :ends
    has_many :shots
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
    
    # validate :check_associations, :check_and_assign_rank
    
    validate :check_and_assign_rank
    before_validation :assign_name


    # ##### helpers (callbacks & validations)
    # auto create name ( ScoreSession.name - RoundFormat.name )
    def assign_name
        if self.score_session && self.round_format
            # if self.name.blank?
                self.name = create_name
            # elsif !self.name.include?(self.score_session.name) || !self.name.include?(self.round_format.name)
                # self.name = create_name
            # end
        end
    end

    def create_name
        "#{self.score_session.name} - #{self.round_format.name}" # if self.round
    end

    # ##### helpers (associated models instantiation)
    def rsets_attributes=(attributes)
        attributes.values.each do |attrs|
            rset = Rset.find(attrs[:id])
            if rset
                rset.update(attrs)
                # pass errors to round which passes them to score_session for views
                self.errors[:rsets] << {rset.id => rset.errors.messages} if rset.errors.any?
            # else
            #     self.rsets.build(rset: rset)
            end
        end
    end

    # ##### helpers (data control)
    def gov_body
        self.score_session.gov_body
    end
    
    def discipline
        self.round_format.discipline
    end
    
    def division
        self.archer_category.division
    end
    
    def age_class
        self.archer_category.age_class
    end

    def gender
        self.archer.gender
    end

    def score
        self.rsets.collect { |rset| rset.score }.sum
    end
    
    def find_category_by_div_age_class(division: division, age_class: age_class)
        Organization::ArcherCategory.find_category(gov_body: self.gov_body, division: division, age_class: age_class, gender: self.gender)
    end
end
