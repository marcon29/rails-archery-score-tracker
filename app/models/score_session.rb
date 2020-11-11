class ScoreSession < ApplicationRecord
    has_many :rounds
    has_many :rsets
    has_many :ends
    has_many :shots
    belongs_to :archer
    belongs_to :gov_body, class_name: "Organization::GovBody"
    
    # assoc attrs - :archer_id
    # data/user attrs - :name :score_session_type :city :state :country :start_date :end_date :rank :active
    # DEPENDENCIES: none

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, scope: :archer, message: "That name is already taken."  }
    validates :score_session_type, 
        presence: { message: "You must choose a score session type." }, 
        inclusion: { in: SCORE_SESSION_TYPES }
    validates :city, presence: { message: "You must enter a city." }
    validates :state, presence: { message: "You must enter a state." }
    validates :country, presence: { message: "You must enter a country." }
    validate :assign_dates, :check_and_assign_rank

    # validates_associated :rounds
    # validates_associated :rsets

    before_validation :format_name
    
    # ##### helpers (callbacks & validations)
    def assign_dates
        if self.start_date.blank?
            errors.add(:start_date, "You must choose a start date.") 
        elsif self.end_date.blank?
            self.end_date = self.start_date
        elsif self.end_date < self.start_date
            errors.add(:end_date, "The end date must come after the start date.")
        end
    end

    def format_name
# binding.pry # 19      score_session validation
        self.name = self.name.titlecase.gsub("Us", "US")
    end

    # ##### helpers (associated models instantiation)
    def rounds_attributes=(attributes)
        attributes.values.each do |attrs|
            round = Round.find(attrs[:id])
# binding.pry # 2

            if round
                # get category from input, then delete input
                attrs[:archer_category_id] = round.find_category_by_div_age_class(division: attrs[:division], age_class: attrs[:age_class]).id
                attrs.delete(:division)
                attrs.delete(:age_class)
                round.update(attrs)
# binding.pry # 5

                # pass errors from rounds to score_session for views
                self.errors[:rounds] << {round.id => round.errors.messages} if round.errors.any?
# binding.pry # 6

            # if new 
            # else
                # need to build out how to create a new round, need to work with RoundFormat
                # attrs[:archer] = self.archer
                # self.rounds.build(round: round)
            end
        end
    end

    def rsets_attributes=(attributes)
        attributes.values.each do |attrs|
            rset = Rset.find(attrs[:id])
# binding.pry # 7, 12

            if rset
                rset.update(attrs)
# binding.pry # 10, 15

                # pass errors from rsets to score_session for views
                self.errors[:rsets] << {rset.id => rset.errors.messages} if rset.errors.any?
# binding.pry # 11, 16

            # else
            #     self.rsets.build(rset: rset)
            end
        end
    end

    # ##### helpers (data control)
        # assign score_method - this code works, just need to determine if needed
            # if attrs[:round_type] == "Qualifying"
            #     attrs[:score_method] = "Points"
            # elsif attrs[:round_type] == "Match"
            #     attrs[:score_method] = "Set"
            # end

        # date range - collect all dates between start and end (inclusive)
            # hold - may not need this - html can restrict date range (can just use start and end)
            # will use to restrict date options for round
        
    
    # all location info
            # should be some gems to better handle this
            # city - make initial cap
            # state - all cap, two letter only
            # country - abbreviations?
    
end
