class Rset < ApplicationRecord
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :set_end_format, class_name: "Format::SetEndFormat"
    # belongs_to :distance_target_category, class_name: "Organization::DistanceTargetCategory"

    # has_one :distance_target_category, through: :archer
    # has_one :target, through: :distance_target_category
    
    # assoc attrs - :archer_id, :score_session_id, :round_id, :set_end_format_id
    # data attrs - :name, :date, :rank
    # user attrs - :date, :rank
    # DEPENDENCIES: 
        # Primary: ScoreSession (for date validation), Round, SetEndFormat (auto-assign name) - need one SetEndFormat per Rset in same Round
        # Secondary: Archer (for Round), RoundFormat (for SetEndFormat)
        # Tertiary: Division, AgeClass, Gender (for Archer - non-assoc)

    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :round }
    validate :check_associations, :check_date, :check_and_assign_rank
    before_validation :assign_name
    

    # ##### helpers (callbacks & validations)

    #####  placeholders to get Shot working independently ######
    ######## remove/edit once DistTargCat assoc working ########
    # shouldn't need this at all, will have direct assoc that Shot can call
    def target
        Format::Target.first
    end

    # should need this so Shot can pull info from Rset instead of assoc
    def distance
        # real code
        # DistanceFormat::TargetCategory.first.distance

        # use til DistTargCat assoc setup for Rset
        "90m"
    end
    ############################################################


    def assign_name
        if self.round && self.set_end_format
            if self.name.blank?
                self.name = create_name
            elsif !self.name.include?(self.round.name) || !self.name.include?(self.set_end_format.name)
                self.name = create_name
            end
        end
    end

    def create_name
        "#{self.round.name} - #{self.set_end_format.name}"
    end

    def check_date
        start_date = self.score_session.start_date if self.score_session
        end_date = self.score_session.end_date if self.score_session

        if self.date.blank?
            errors.add(:date, "You must choose a start date.")
        elsif self.date < start_date || self.date > end_date
            errors.add(:date, "Date must be between #{start_date} and #{end_date}.")
        end
    end

    # ##### helpers (data control)
    def round_format
        self.round.round_format
    end

    def num_ends
        self.set_end_format.num_ends
    end

    def shots_per_end
        self.set_end_format.shots_per_end
    end

    def score
        self.ends.collect { |endd| endd.score }.sum
    end

    # it "can calculate the total score for a rset" do
        # pending "need to add associations"
        # want to be able to to call rset.score
        # sums all end scores
    # end

    # need to get distance and target (same process for each)
        # find archer_category from Archer that matches:
            # assoc_round.discipline && assoc_round.division && assoc_round.age_class
        # look up distance and target from distance_target_category that matches found archer_category
        
        
end
