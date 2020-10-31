class Format::RoundFormat < ApplicationRecord
    has_many :set_end_formats
    has_many :rounds
    has_many :distance_target_categories, class_name: "Organization::DistanceTargetCategory"
    
    
    # all attrs - :name, :num_sets, :user_edit

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :num_sets, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    validate :check_user_edit, on: :update
    before_validation :format_name

    # helpers (callbacks & validations)
    def format_name
        self.name = self.name.titlecase
    end
end

