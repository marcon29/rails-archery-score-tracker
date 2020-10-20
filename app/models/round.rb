class Round < ApplicationRecord

    # need to add associations
        # has_many :shots
        # has_many :archers, :score_sessions, :round_sets, through: :shots
        # has_many :archer_categories, through: :round_sets
    
    # all attrs - :name, :discipline, :round_type, :num_roundsets, :user_edit

    # need to add validations
        # required - :name, :discipline, :round_type, :num_roundsets, :user_edit (auto)
            # "You must enter a name."
            # "You must choose a discipline."
            # "You must choose a round type."
            # "You must enter the number of distances/sets for this round."
        # unique - :name
            # "That name is already taken."
        # inclusion - :discipline ( DISCIPLINES ), :round_type ( ROUND_TYPES )
        # format - :num_roundsets (integer)

        

    # need to callback methods
        # auto-assign user_edit
            # if pre-load, false
            # if user-loead, true
        # format name - init cap

    # need to helper methods


end
