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
# binding.pry # update 19  score_session validation
# binding.pry # new 4      score_session validation
    end

    def format_name
        self.name = self.name.titlecase.gsub("Us", "US")
    end
    
    # ##### helpers (associated models instantiation)
    def rounds_attributes=(attributes)
        self.validate if self.id

        attributes.values.each do |attrs|
            round = Round.find(attrs[:id]) if attrs[:id]
            # binding.pry # 2
            if round    # if existing/update
                # get category from input, then delete input
                attrs[:archer_category_id] = round.find_category_by_div_age_class(division: attrs[:division], age_class: attrs[:age_class]).id
                attrs.delete(:division)
                attrs.delete(:age_class)
                round.update(attrs)
                # binding.pry # update 5
                
                # pass errors from rounds to score_session for views
                self.errors[:rounds] << {round.id => round.errors.messages} if round.errors.any?
                # binding.pry # update 6
            else
                # binding.pry # new 5
                attrs[:archer_id] = self.archer.id
                attrs[:archer_category_id] = Organization::ArcherCategory.find_category(
                    gov_body: self.gov_body, 
                    division: attrs[:division], 
                    age_class: attrs[:age_class], 
                    gender: self.archer.gender
                ).id
                attrs.delete(:division)
                attrs.delete(:age_class)

                if self.save
                    round = self.rounds.create(attrs)   # runs round validations only
                    # binding.pry # new 7

                    round.round_format.set_end_formats.each do |sef|
                        rset_attrs = {archer: self.archer, score_session: self, set_end_format: sef}
                        rset = round.rsets.create(rset_attrs)    # runs rset validations only
                        # binding.pry # new 9

                        end_attrs = {archer: self.archer, score_session: self, round: round, rset: rset}
                        sef.num_ends.times do 
                            endd = rset.ends.create(end_attrs)    # runs end validations only
                            # binding.pry # new 11

                            shot_attrs = {archer: self.archer, score_session: self, round: round, rset: rset, end: endd}
                            sef.shots_per_end.times do
                                shot = endd.shots.create(shot_attrs)
                            end
                            # binding.pry # new 13
                        end
                    end
                else
                    round = self.rounds.build(attrs)
                end
            end
            # binding.pry # new 14     one fully built round
        end
        # binding.pry # new 15     one fully built score session
    end

    def rsets_attributes=(attributes)
        attributes.values.each do |attrs|
            rset = Rset.find(attrs[:id])
            # binding.pry # 7, 12

            if rset
                rset.update(attrs)
                # binding.pry # 10, 15

                # pass errors from rsets to score_session for views
                if self.start_date.blank? && rset.errors.messages[:date].first
                    rset.errors.messages[:date][0] = "You need a score session start date above."
                end
                self.errors[:rsets] << {rset.id => rset.errors.messages} if rset.errors.any?
                # binding.pry # 11, 16
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
