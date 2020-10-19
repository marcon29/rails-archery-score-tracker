class ScoreSession < ApplicationRecord
    # need to add associations
        # has_many :shots
        # has_many :rounds, :round_sets, through: :shots
        # has_one archer, through: :shots
        # has_many :archer_categories, through: :round_sets

    # all attrs  -  :name :score_session_type :city :state :country :start_date :end_date :rank :active

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :score_session_type, 
        presence: { message: "You must choose a score session type." }, 
        inclusion: { in: SCORE_SESSION_TYPES }
    validates :city, presence: { message: "You must enter a city." }
    validates :state, presence: { message: "You must enter a state." }
    validates :country, presence: { message: "You must enter a country." }
    validates :start_date, presence: { message: "You must choose a start date." }
    validates :end_date, presence: true
    before_validation :assign_dates
    
    # callbacks (validations): 
    #     assign_end_date - if blank same as start_date
    #     format_rank - take integer as input, add "st" "nd" "rd" "th" as necessary
    #         need ability to use "W" or "L" ???
    #     format :start_date :end_date
    # callbacks (save):
    #     format name - init cap

    # refactor to use same method as date formatting in Archer???
    def assign_dates
        self.start_date = format_date(self.start_date) if !self.start_date
        self.end_date = format_date(self.end_date) if !self.end_date
    end

    def format_date(date_string)
        date_string.to_date.strftime("%m/%d/%Y")
    end



    # need helpers
        # date range - collect all dates between start and end (inclusive)
            # will use to restrict date options for round
    
    
    # rank
        # need ability to use "W" or "L" ???
        # would need to input to be text not number
        # would need to add inclusive validation

    # all location info
            # should be some gems to better handle this
            # city - make initial cap
            # state - all cap, two letter only
            # country - abbreviations?


    
end
