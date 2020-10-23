class RoundFormat < ApplicationRecord

    # need to add associations
        # has_many :set_end_formats
        
    
    # old attrs - :name, :discipline, :round_type, :num_roundsets, :user_edit

    # all attrs - :name, :round_type, :rank
    # format attrs - :name, :num_sets, :user_edit

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :num_sets, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    before_validation :format_name


    # callbacks/validation helpers
    def format_name
        self.name = self.name.titlecase
    end

    # need other helper methods
    

        


end
