class Format::SetEndFormat < ApplicationRecord
    belongs_to :round_format
    has_many :rsets
    
    # all attrs - :name, :num_ends, :shots_per_end, :user_edit

    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :round_format }
    validates :num_ends, :shots_per_end, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    before_validation :assign_name


    # helpers (callbacks & validations)
    def assign_name 
        if self.name.blank? && self.round_format
            self.name = create_name
        end
    end

    def create_name
        "Set/Distance#{self.set_number}"
    end

    def set_number
        sets_in_round.count + 1
    end

    def sets_in_round
        self.round_format.set_end_formats if self.round_format
    end 
end