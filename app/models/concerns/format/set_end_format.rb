class Format::SetEndFormat < ApplicationRecord
    belongs_to :round_format
    
    # all attrs - :name, :num_ends, :shots_per_end, :user_edit

    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :round_format }
    validates :num_ends, :shots_per_end, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    before_validation :assign_name


    # helpers (callbacks & validations)
    def assign_name
        if self.name.blank?
            self.name = "Set/Distance#{self.all_sets_in_same_round.count + 1}" if self.round_format
        end
    end

    def all_sets_in_same_round
        self.round_format.set_end_formats if self.round_format
    end
end