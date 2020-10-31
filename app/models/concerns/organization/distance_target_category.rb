class Organization::DistanceTargetCategory < ApplicationRecord
    def self.table_name
        'organization_dist_targ_cats'
    end

    belongs_to :round_format, class_name: "Format::RoundFormat"
    belongs_to :set_end_format, class_name: "Format::SetEndFormat"
    belongs_to :archer_category
    belongs_to :target, class_name: "Format::Target"
    belongs_to :alt_target, class_name: "Format::Target"#, foreign_key: "alt_target_id"
    # has_many :rsets
    
    # assoc attrs - :round_format_id, :set_end_format_id, :archer_category_id, :target_id, :alt_target_id
    # data attrs  - :distance

    # Regular user can't update these - only for app to reference. Validations to ensure data integrity when extending app.
    # validates :distance, presence: true

    
    # needs to lookup the category by age/div/gender (input at Round creation)
    # knowing the Round, the Set and the Archer Category can proide the Distance and Target
    # Round             Set                 Category                Distance        Target          Alt Target
    # ---------------   ----------------    ------------------      --------        ---------       -------------
    # round_format_id   set_end_fomat_id    archer_category_id      attr            target_id       alt_target_id
    # ---------------   ----------------    ------------------      --------        ---------       -------------
    # 1440              Distance 1          R Sr. M                 90m             122cm           nil
    # 1440              Distance 3          C Cad. W                40m             80cm            80cm/6-ring
    # 720               Distance 2          R Mast. M               60m             122cm           nil
    # 720               Distance 2          C Mast. M               60m             122cm           nil
    
    # ##### helpers (callbacks & validations)

    # ##### helpers (data control)
        # will then need logic to recognize alt target and allow user to select
            # add Target to array
            # if alt_Target, also add to array
            # return array
                # can use collection for UX selection options
            # will need assoc to Rset
    
    
    # below is controller behavior, not model. Just need to ensure for models
        # Round can find a category by AgeClass (user input), Archer.gender, and Division (user input)
    # archer can often shoot outside their default category
        # info needs to come from Round
        # info from Round determines: Set, Division, AgeClass
        # info from Archer determines: Gender and age
        # use Division, AgeClass (from Round) and Gender (from Archer) to find ArcherCategory
        # use ArcherCategory (calculated), RoundFormat and SetEndFormat to find distance, Target, and alt_Target
    
    # an Archer does not have a category, they have a collection of elgibile categories
    # a Round has one category (options filtered by Archer eligibility)
        # needs to find that category by combo of:
            # division (completely open)
            # age_class (limited by Archer age)
            # gender (limited by Archer gender)
    
end
