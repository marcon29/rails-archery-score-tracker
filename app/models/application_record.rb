class ApplicationRecord < ActiveRecord::Base
	self.abstract_class = true
  
	def check_and_assign_rank
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
end