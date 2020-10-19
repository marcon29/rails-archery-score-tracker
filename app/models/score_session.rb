class ScoreSession < ApplicationRecord
    # need to add associations
        # has_many :shots
        # has_many :rounds, :round_sets, through: :shots
        # has_one archer, through: :shots
        # has_many :archer_categories, through: :round_sets

    # all attrs  -  :name :score_session_type :city :state :country :start_date :end_date :rank :active

    # need to add validations
        # required: :name :score_session_type :city :state :country :start_date :end_date :active
        # unique: :name 
        # inclusion: :score_session_type (SCORE_SESSION_TYPES) 
        # format: :start_date :end_date :rank 
        # callbacks (validations): 
        #     assign_end_date - if blank same as start_date
        #     format_rank - take integer as input, add "st" "nd" "rd" "th" as necessary
        #     # need ability to use "W" or "L" ???
        # callbacks (save): 
        #     format name - init cap


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
