class Rset < ApplicationRecord
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :score_session
    belongs_to :round
    belongs_to :set_end_format, class_name: "Format::SetEndFormat"
    belongs_to :distance_target_category, class_name: "Organization::DistanceTargetCategory"
    has_one :target, through: :distance_target_category
    has_one :alt_target, through: :distance_target_category

    # assoc attrs - :archer_id, :score_session_id, :round_id, :set_end_format_id
    # data attrs - :name, :date, :rank
    # user attrs - :date, :rank
    # DEPENDENCIES: 
        # Primary: ScoreSession (for date validation), Round, SetEndFormat (auto-assign name) - need one SetEndFormat per Rset in same Round, DistanceTargetCategory (for auto_assign)
        # Secondary: Archer (for Round), RoundFormat (for SetEndFormat)
        # Tertiary: Division, AgeClass, Gender (for Archer - non-assoc)

    validates :name, 
        presence: true, 
        uniqueness: { case_sensitive: false, scope: :round }
    # validates :rank, 
    #     presence: { message: "You must enter a rank if Set/Distance complete." }, 
    #     if: :complete?
    validate :check_associations, :check_date, :check_and_assign_rank
    before_validation :assign_name, :assign_dist_targ_cat
    

    # ##### helpers (callbacks & validations)
    def assign_name
        if self.round && self.set_end_format
            self.name = create_name
        end
    end

    def create_name
        "#{self.round.name} - #{self.set_end_format.name}"
    end

    def check_date
        start_date = self.score_session.start_date if self.score_session
        end_date = self.score_session.end_date if self.score_session

# binding.pry # update 8, 13    rset validation
# binding.pry # new 8           rset validation

        if scoring_started? 
            if start_date == end_date
                self.date = start_date
            elsif self.date.blank? || self.date < start_date || self.date > end_date 
                errors.add(:date, "Date must be between #{start_date} and #{end_date}.")
            end                
        elsif self.date
            if self.date < start_date || self.date > end_date 
                if start_date == end_date
                    errors.add(:date, "Date must be #{start_date} or leave blnak.") 
                else
                    errors.add(:date, "Date must be between #{start_date} and #{end_date} or leave blnak.")
                end
            end
        end
    end

    def archer_category
        self.round.archer_category if self.round
    end

    def assign_dist_targ_cat
        if self.set_end_format && self.archer_category
            self.distance_target_category = find_dist_targ_cat
        end
    end

    def find_dist_targ_cat
        Organization::DistanceTargetCategory.find_dtc_by_set_cat(set_end_format: self.set_end_format, archer_category: self.archer_category)
    end
    

    # ##### helpers (data control)
    def distance
        self.distance_target_category.distance
    end

    # not sure if I need this - test in spec file, also commented out
    # def round_format
    #     self.round.round_format
    # end

    def num_ends
        self.set_end_format.num_ends
    end

    def shots_per_end
        self.set_end_format.shots_per_end
    end

    def num_ends
        self.set_end_format.num_ends
    end

    def shots_per_rset
        self.shots_per_end*self.num_ends
    end

    def set_num
        self.name.last.to_i
    end

    def active?
        if set_num == 1 
            self.incomplete?
        else
            # previous = Rset.find_by(name: "#{self.round.name} - Set/Distance#{set_num-1}")
            previous = self.round.rsets.find_by(name: "#{self.round.name} - Set/Distance#{set_num-1}")
            previous.complete? && self.incomplete?
        end
    end

    def score
        self.ends.collect { |endd| endd.score }.sum
    end 
end
