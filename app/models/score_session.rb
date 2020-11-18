class ScoreSession < ApplicationRecord
    has_many :rounds, dependent: :destroy
    has_many :rsets, dependent: :destroy
    has_many :ends, dependent: :destroy
    has_many :shots, dependent: :destroy
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
        self.name = self.name.titlecase.gsub("Us", "US")
    end
    
    # ##### nested, associated models instantiation
    def rounds_attributes=(attributes)
        self.update(start_date: self.start_date, end_date: self.end_date) if self.id

        attributes.values.each do |round_attrs|
            round_attrs[:archer] = self.archer
            round_attrs[:archer_category] = Organization::ArcherCategory.find_category(
                gov_body: self.gov_body, 
                division: round_attrs[:division], 
                age_class: round_attrs[:age_class], 
                gender: self.archer.gender
            )
            round_attrs.delete(:division)
            round_attrs.delete(:age_class)

            round = Round.find(round_attrs[:id]) if round_attrs[:id]

            if round    # if existing/update
                round.update(round_attrs)
                self.errors[:rounds] << {round.id => round.errors.messages} if round.errors.any?
            elsif self.save    # if new/create
                create_full_round(round_attrs)
            else
                round = self.rounds.build(round_attrs)      # allows Round fields to re-render
            end
        end
    end

    def create_full_round(round_attrs)
        round = self.rounds.create(round_attrs)   # runs round validations only
        create_rsets_ends_shots(round)
    end

    def create_rsets_ends_shots(round)
        round.round_format.set_end_formats.each do |sef|
            rset_attrs = {archer: self.archer, score_session: self, set_end_format: sef}
            rset = round.rsets.create(rset_attrs)    # runs rset validations only
            create_ends_shots(round, rset, sef)
        end
    end

    def create_ends_shots(round, rset, set_end_format)
        end_attrs = {archer: self.archer, score_session: self, round: round, rset: rset}
        set_end_format.num_ends.times do 
            endd = rset.ends.create(end_attrs)    # runs end validations only
            create_shots(round, rset, endd, set_end_format)
        end
    end

    def create_shots(round, rset, endd, set_end_format)
        shot_attrs = {archer: self.archer, score_session: self, round: round, rset: rset, end: endd}
        set_end_format.shots_per_end.times do
            shot = endd.shots.create(shot_attrs)
        end
    end

    def rsets_attributes=(attributes)
        attributes.values.each do |attrs|
            rset = Rset.find(attrs[:id])
            if rset
                rset.update(attrs)

                if self.start_date.blank? && rset.errors.messages[:date].first
                    rset.errors.messages[:date][0] = "You need a score session start date above."
                end
                self.errors[:rsets] << {rset.id => rset.errors.messages} if rset.errors.any?
            end
        end
    end

    # ##### helpers (data control)
    def single_day?
        self.end_date == self.start_date
    end

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
