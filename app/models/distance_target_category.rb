class DistanceTargetCategory < ApplicationRecord
    belongs_to :target
    belongs_to :archer_category    
    belongs_to :round
    belongs_to :rset

    # all attrs  - :round_id, :rset_id, :archer_category_id, :distance, :target_id 
    # assoc attrs  - :rset_id, :archer_category_id, :target_id
    # data attrs  - :distance
    
    # Regular user can't update these - pre-loaded for reference by rest of app only.
    # Validations to ensure data integrity when extending app. No need to display error messages.
    validates :distance, presence: true

    # targets and distances depends on:
        # archer category
            # division (recurve/compound)
            # archer age
            # archer gender
        # the Set
        # the target
        # the distance
    # needs to lookup the category by age/div/gender (input at Round creation)
    
    # knowing the Round, the Set and the Archer Category can proide the Distance and Target
    # Round         Set             Category          Distance        Target
    # 1440          Distance 1      R Sr. M            90m             122cm
    # 1440          Distance 3      C Cad. W           40m             80cm
    # 720           Distance 2      R Mast. M          60m             122cm
    # 720           Distance 2      C Mast. M          60m             122cm

    # wrinkles to think out
    # target options??? - can often choose between single and multi-spot
        # will need multiple entries
            # alternate target column? - less records
            # multiple columns with only target difference
                # will then need logic to recognize multiple returns and display options to select
    
    
    # below is controller behavior, not model. Just need to ensure for models
        # Round can find a category by AgeClass (user input), Archer.gender, and Division (user input)
    # archer can often shoot outside their default category
        # info needs to come from Round
        # info from Round determines: Set, division, age_class
        # info from Archer determines: Gender and age
    
    # an Archer does not have a category, they have a collection of elgibile categories
    # a Round has one category (options filtered by Archer eligibility)
        # needs to find that category by combo of:
            # division (completely open)
            # age_class (limited by Archer age)
            # gender (limited by Archer gender)
    
end
