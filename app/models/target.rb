class Target < ApplicationRecord
    has_many :distance_target_categoriess
    has_many :archer_categories, through: :distance_target_categoriess
    has_many :archers, through: :distance_target_categoriess
    
    # all data attrs  - :name, :size, :score_areas, :rings, :x_ring, :max_score, :spots, :user_edit

    validates :name, presence: true, uniqueness: true
    validates :size, presence: { message: "You must provide a target size." }
    validates :x_ring, presence: { message: "You must specifiy if there is an X ring." }
    validates :score_areas, :rings, :max_score, :spots, 
        numericality: { only_integer: true, greater_than: 0, message: "You must enter a number greater than 0." }
    before_validation :assign_name

    def assign_name
        self.name = create_name
    end

    def create_name
        "#{self.size}/#{self.spots}-spot/#{self.rings}-ring"
    end
end


