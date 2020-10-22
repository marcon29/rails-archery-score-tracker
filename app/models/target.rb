class Target < ApplicationRecord
        
    # all data attrs  - :name, :size, :score_areas, :rings, :x_ring, :max_score, :spots, :user_edit

    has_many :distance_targets
    has_many :archer_categories, through: :distance_targets
    has_many :archers, through: :distance_targets
    
    validates :name, presence: true, uniqueness: true
    validates :size, presence: { message: "You must provide a target size." }
    validates :score_areas, presence: { message: "You must provide the number of scoring areas." }
    validates :rings, presence: { message: "You must provide the number of rings." }
    validates :x_ring, presence: { message: "You must specifiy if there is an X ring." }
    validates :max_score, presence: { message: "You must provide the higest score value." }
    validates :spots, presence: { message: "You must specify the number of spots." }
    before_validation :assign_name

    def assign_name
        self.name = create_name
    end

    def create_name
        "#{self.size}/#{self.spots}-spot/#{self.rings}-ring"
    end
end


