class ScoreSession < ApplicationRecord
    has_many :rounds
    has_many :rsets
    has_many :ends
    has_many :shots
    belongs_to :archer

    # all attrs  -  :name :score_session_type :city :state :country :start_date :end_date :rank :active

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, scope: :archer, message: "That name is already taken."  }
    validates :score_session_type, 
        presence: { message: "You must choose a score session type." }, 
        inclusion: { in: SCORE_SESSION_TYPES }
    validates :city, presence: { message: "You must enter a city." }
    validates :state, presence: { message: "You must enter a state." }
    validates :country, presence: { message: "You must enter a country." }
    validate :assign_dates, :check_and_assign_rank
    before_validation :format_name

    
    # ##### helpers (callbacks & validations)
    def assign_dates
        if self.start_date.blank?
            errors.add(:start_date, "You must choose a start date.")
        elsif self.end_date.blank?
            self.end_date = self.start_date
        end
    end

    def format_name
        self.name = self.name.titlecase
    end

    # ##### helpers (data control)
        # date range - collect all dates between start and end (inclusive)
            # hold - may not need this - html can restrict date range (can just use start and end)
            # will use to restrict date options for round
        
    
    # all location info
            # should be some gems to better handle this
            # city - make initial cap
            # state - all cap, two letter only
            # country - abbreviations?
    
end
