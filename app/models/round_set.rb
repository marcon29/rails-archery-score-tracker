class RoundSet < ApplicationRecord
    # has_many :archers, score_sessions, rounds, through: :shots

    has_many :distance_targets
    has_many :archer_categories, through: :distance_targets
    has_many :targets, through: :distance_targets

    validates :name, presence: true, uniqueness: true
    validates :ends, :shots_per_end, numericality: { only_integer: true }
    validates :score_method, presence: true, inclusion: { in: SCORE_METHODS }
    # before_validation :assign_name


    # need helpers        
        # need to auto-create name ("Round name" + "set/distance 1")
        # need to assign auto-created name to object
        # examples from Target model
            # def assign_name
            #     self.name = create_name
            # end
        
            # def create_name
            #     "#{self.size}/#{self.spots}-spot/#{self.rings}-ring"
            # end

end
