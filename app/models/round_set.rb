class RoundSet < ApplicationRecord

    # has_many :archers, score_sessions, rounds, through: :shots

    # has_many :distance_targets
    # has_many :archer_categories, through: :distance_targets
    # has_many :targets, through: :distance_targets

    
    validates :name, presence: true, uniqueness: true
    validates :ends, numericality: { only_integer: true }
    validates :shots_per_end, numericality: { only_integer: true }
    validates :score_method, presence: true, inclusion: { in: SCORE_METHODS }
    # callbacks: before validations - assign name



    # need helpers        
        # need to auto-create name ("Round name" + "set/distance 1")
        # need to assign auto-created name to object

end
