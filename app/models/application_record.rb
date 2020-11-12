class ApplicationRecord < ActiveRecord::Base
	self.abstract_class = true
  
	# tests for this are in ScoreSession
	def check_and_assign_rank
# binding.pry # 4, 9, 14, 20
		allowable_ranks = [/\A\d+st\z/i, /\A\d+nd\z/i, /\A\d+rd\z/i, /\A\d+th\z/i, /\A\d+\z/, /\AW\z/i, /\AL\z/i, /\Awin\z/i, /\Aloss\z/i, /\Awon\z/i, /\Alost\z/i]
		# allows all numbers only: /\A\d+\z/ ( checks below for not 0: /\A^0+\z/ )
			# allows all numbers except 0 (checked below) ending with 'st' 'nd' 'rd' 'th' (case insenitive): /\A\d+st\z/i, /\A\d+nd\z/i, /\A\d+rd\z/i, /\A\d+th\z/i
			# allowable text  (case insenitive): W, L, win, loss, won, lost
	
		if self.rank.present?
			string = self.rank.strip.gsub(" ", "").downcase
			if string.scan(Regexp.union(allowable_ranks)).empty? || string.match(Regexp.union(/\A^0+\z/, /\A^0+st\z/i, /\A^0+nd\z/i, /\A^0+rd\z/i, /\A^0+th\z/i))
				errors.add(:rank, 'Enter only a number above 0, "W" or "L".')
			else
				self.assign_rank(string)
			end
		end
	end

	# tests for this are in ScoreSession
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

	def check_associations
		array = []

		if self.class == Shot || self.class == End || self.class ==  Rset || self.class ==  Round
			array << (self.archer == self.score_session.archer)
		end

		if self.class == Shot || self.class == End || self.class ==  Rset
			array << (self.score_session == self.round.score_session)
			array << (self.archer == self.round.archer)
		end

		if self.class == Shot || self.class == End
			array << (self.round == self.rset.round)
			array << (self.score_session == self.rset.score_session)
			array << (self.archer == self.rset.archer)
		end

		if self.class == Shot
			array << (self.rset == self.end.rset)
			array << (self.round == self.end.round)
			array << (self.score_session == self.end.score_session)
			array << (self.archer == self.end.archer)
		end
		
		if array.include?(false)
			errors.add(:score_session, "Must have the same Archer as the Score Session.") if array[0] == false
			errors.add(:round, "Must have the same Score Session as the Round.") if array[1] == false
			errors.add(:round, "Must have the same Archer as the Round.") if array[2] == false
			errors.add(:rset, "Must have the same Round as the Set.") if array[3] == false
			errors.add(:rset, "Must have the same Score Session as the Set.") if array[4] == false
			errors.add(:rset, "Must have the same Archer as the Set.") if array[5] == false
			errors.add(:end, "Must have the same Set as the End.") if array[6] == false
			errors.add(:end, "Must have the same Round as the End.") if array[7] == false
			errors.add(:end, "Must have the same Score Session as the End.") if array[8] == false
			errors.add(:end, "Must have the same Archer as the End.") if array[9] == false
		else
			array
		end
	end

	def get_data_columns
		self.class.column_names.select do |col| 
			col != "id" && col != "created_at" && col != "updated_at" && !col.ends_with?("_id")
		end
	end
	
	def check_user_edit
		if self.user_edit == false
			message = "You can't change a pre-loaded #{self.class.to_s}."
			get_data_columns.each { |col| errors.add("#{col}", message) }
		end
	end

	def full_location
		"#{self.city}, #{self.state}, #{self.country}"
	end

	def scoring_started?
        all_entries = self.shots.all.reject { |shot| shot.score_entry if shot.score_entry == "" }
        all_entries.present?
    end

end