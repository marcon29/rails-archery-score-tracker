class RoundSet < ApplicationRecord

    # (name: "", ends: "", shots_per_end: "", score_method: "")

# need to add associations
    # has_many :archers, score_sessions, rounds, through: :shots

    # has_many :distance_targets
    # has_many :archer_categories, through: :distance_targets
    # has_many :targets, through: :distance_targets



# need validations
    # required: :name :ends :shots_per_end :score_method
    # unique: :name
    # restrict data: :ends (number) :shots_per_end (number) :score_method(SCORE_METHODS)
    # callbacks: before validations - assign name
    


# need helpers        
    # need to auto-create name ("Round name" + "set/distance 1")
    # need to assign auto-created name to object
    
        




end
