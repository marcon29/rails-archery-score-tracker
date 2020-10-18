class DistanceTarget < ApplicationRecord
    belongs_to :target
    belongs_to :archer_category    
    belongs_to :round_set
    
    # Regular user can't update these - pre-loaded for reference by rest of app only.
    # Validations to ensure data integrity when extending app. No need to display error messages.
    validates :distance, :target_id, :archer_category_id, :round_set_id, presence: true
    
    def distance_from_input(num, unit)
        "#{num}#{unit}"
    end
end
