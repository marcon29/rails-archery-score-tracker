class DistanceTargetCategory < ApplicationRecord
    belongs_to :target
    belongs_to :archer_category    
    belongs_to :archer

    # all attrs  - :distance target_id :archer_category_id :archer_id
    
    # Regular user can't update these - pre-loaded for reference by rest of app only.
    # Validations to ensure data integrity when extending app. No need to display error messages.
    validates :distance, :target_id, :archer_category_id, :archer_id, presence: true
    
end
