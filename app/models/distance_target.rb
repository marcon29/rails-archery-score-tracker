class DistanceTarget < ApplicationRecord

    # need to add associations


    # Regular user can't update these directly, pre-loaded for reference by rest of app only,
    # but validations still helpful to ensure data integrity when extending app.
    # This also means there's no need to  display error messages.
    validates :distance, :target_id, :archer_category_id, :set_id, presence: true
    
    def distance_from_input(num, unit)
        "#{num}#{unit}"
    end
end
