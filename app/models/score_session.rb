class ScoreSession < ApplicationRecord
    # need to add associations
        # has_many :shots
        # has_many :rounds, :round_sets, through: :shots
        # has_one archer, through: :shots
        # has_many :archer_categories, through: :round_sets

    # all attrs  -  :name :score_session_type :city :state :country :start_date :end_date :rank :active

    validates :name, 
        presence: { message: "You must enter a name." }, 
        uniqueness: { case_sensitive: false, message: "That name is already taken." }
    validates :score_session_type, 
        presence: { message: "You must choose a score session type." }, 
        inclusion: { in: SCORE_SESSION_TYPES }
    validates :city, presence: { message: "You must enter a city." }
    validates :state, presence: { message: "You must enter a state." }
    validates :country, presence: { message: "You must enter a country." }
    validate :assign_dates, :check_and_assign_rank
    before_validation :format_name

    
    # callbacks/validation helpers 
    def assign_dates
        if self.start_date.blank?
            errors.add(:start_date, "You must choose a start date.")
        elsif self.end_date.blank?
            self.end_date = self.start_date
        end
    end

    def format_name
        self.name = self.name.titlecase
    end

    def check_and_assign_rank        
        allowable_ranks = [/\A\d+st\z/i, /\A\d+nd\z/i, /\A\d+rd\z/i, /\A\d+th\z/i, /\A\d+\z/, /\AW\z/i, /\AL\z/i, /\Awin\z/i, /\Aloss\z/i, /\Awon\z/i, /\Alost\z/i]
            # allows all numbers only: /\A\d+\z/ ( checks below for not 0: /\A^0+\z/ )
            # allows all numbers except 0 (checked below) ending with 'st' 'nd' 'rd' 'th' (case insenitive): /\A\d+st\z/i, /\A\d+nd\z/i, /\A\d+rd\z/i, /\A\d+th\z/i
            # allowable text  (case insenitive): W, L, win, loss, won, lost
        if self.rank.present?
            string = self.rank.strip.gsub(" ", "").downcase
        
            if string.scan(Regexp.union(allowable_ranks)).empty? #|| string.match(Regexp.union(/\A^0+\z/, /\A^0+st\z/i, /\A^0+nd\z/i, /\A^0+rd\z/i, /\A^0+th\z/i))
                errors.add(:rank, 'Enter only a number above 0, "W" or "L".')
            else
                self.assign_rank(string)
            end
        end
    end

    def assign_rank(rank)
        if rank.starts_with?("W", "w")
            string = "Win"
        elsif rank.starts_with?("L", "l")
            string = "Loss"
        else
            stripped = rank.to_i.to_s
            string = "#{stripped}th"
            string = "#{stripped}st" if stripped.ends_with?("1")
            string = "#{stripped}nd" if stripped.ends_with?("2")
            string = "#{stripped}rd" if stripped.ends_with?("3")
            string = "#{stripped}th" if stripped.ends_with?("11")
        end
        self.rank = string
    end

    # need helpers
        # date range - collect all dates between start and end (inclusive)
            # hold - may not need this - html can restrict date range (can just use start and end)
            # will use to restrict date options for round
    
    # all location info
            # should be some gems to better handle this
            # city - make initial cap
            # state - all cap, two letter only
            # country - abbreviations?
    
end
