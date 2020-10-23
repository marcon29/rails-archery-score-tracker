class SetEndFormat < ApplicationRecord
    # need to add associations
        # belongs_to :round_format

    # old attrs - :name, :ends, :shots_per_end, :score_method
    # all attrs - :name, :num_ends, :shots_per_end, :user_edit

    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :round_format }
    validates :num_ends, :shots_per_end, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }


    # need helpers
        # need to auto create name ( Set/Distance + (RoundFormat.SetEndFormats.count + 1) )
  

end
