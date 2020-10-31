class Organization::DistanceTargetCategory < ApplicationRecord
    def self.table_name
        'organization_dist_targ_cats'
    end

    belongs_to :set_end_format, class_name: "Format::SetEndFormat"
    belongs_to :archer_category
    belongs_to :target, class_name: "Format::Target"
    belongs_to :alt_target, class_name: "Format::Target", optional: true
    # has_many :rsets
    
    # assoc attrs - :round_format_id, :set_end_format_id, :archer_category_id, :target_id, :alt_target_id
    # data attrs  - :distance

    # Regular user can't update these - only for app to reference. Validations to ensure data integrity when extending app.
    validates :distance, presence: true

    
    # ##### helpers (data control)
    def round_format
        self.set_end_format.round_format
    end

    def has_alt_target?
        !!self.alt_target
    end

    def target_options
        all_targets = [self.target]
        all_targets.push(self.alt_target) if alt_target
        all_targets
    end
end
