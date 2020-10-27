class Rset < ApplicationRecord
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    
    # has_one :distance_target_category, through: :archer
    # has_one :target, through: :distance_target_category
    
    # all attrs - :name, :date, :rank
    # dependencies: ScoreSession, Round

    validates :name, presence: true, uniqueness: true
    validate :check_date, :check_and_assign_rank
    before_validation :assign_name
    

    # need helpers (callbacks & validations)
    def check_date
        # start_date = self.score_session.start_date
        # end_date = self.score_session.end_date

        # using this until associations and controller set up
        start_date = ScoreSession.first.start_date
        end_date = ScoreSession.first.end_date

        if self.date.blank?
            errors.add(:date, "You must choose a start date.")
        elsif self.date < start_date || self.date > end_date
            errors.add(:date, "Date must be between #{start_date} and #{end_date}.")
        end
    end
    
    # need to auto create name ( Round.name - SetEndFormat.name )
        # SetEndFormat.name will be input by controller, not via assoc.
        
    def assign_name
        # can't use an arg
        # self.name = create_name
        
        # using this until associations and controller set up
        self.name = create_name("Set/Distance2") if self.name.blank?
    end

    def create_name(input)
        # "#{self.round.name} - #{input}"

        # using this until associations and controller set up
        temp = "1440 Round"
        "#{temp} - #{input}"
    end
       
    
    
        

    # need helpers
        # need to get distance and target (same process for each)
            # find archer_category from Archer that matches:
                # assoc_round.discipline && assoc_round.division && assoc_round.age_class
            # look up distance and target from distance_target_category that matches found archer_category
        
        # it "can calculate the total score for a rset" do
            # pending "need to add associations"
            # want to be able to to call rset.score
            # sums all end scores
        # end

        
  

end
