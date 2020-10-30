class Rset < ApplicationRecord
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :set_end_format, class_name: "Format::SetEndFormat"

    # has_one :distance_target_category, through: :archer
    # has_one :target, through: :distance_target_category
    
    # all attrs - :name, :date, :rank
    # dependencies: ScoreSession (for validating date), Round (for name creation)

    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :round }
    validate :check_date, :check_and_assign_rank
    before_validation :assign_name
    

    # need helpers (callbacks & validations)
    def check_date
        start_date = self.score_session.start_date if self.score_session
        end_date = self.score_session.end_date if self.score_session

        if self.date.blank?
            errors.add(:date, "You must choose a start date.")
        elsif self.date < start_date || self.date > end_date
            errors.add(:date, "Date must be between #{start_date} and #{end_date}.")
        end
    end
    
    # auto create name ( ScoreSession.name - Round.name - Rset.name )
    def assign_name
        if self.round && self.set_end_format
            if self.name.blank?
                self.name = create_name
            elsif !self.name.include?(self.round.name) || !self.name.include?("Set/Distance")
                self.name = create_name
            end
        end
    end

    def create_name
        "#{self.round.name} - Set/Distance#{self.set_number}" # if self.round
    end

    def set_number
        sets_in_round.count + 1
    end

    def sets_in_round
        self.round.rsets if self.round
    end 

    # need helpers
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
