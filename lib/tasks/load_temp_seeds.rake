# ################################################
# Archer build helpers
# ################################################
def get_gender(code)
	if code.last == "w"
		1
	else
		2
	end
end

def get_div(code)
	if code.first == "c"
		["CO", "Compound"]
	else
		["RI", "Recurve"]
	end
end

def get_age_class(code)
	array = code.split("")
	array.pop
	array.shift
	array.join
end

def get_details(code)
	case get_age_class(code)
		when "b"
			["2008-07-01", "Bowman"]
		when "u"
			["2006-07-01", "Cub"]
		when "c"
			["2003-07-01", "Cadet"]
		when "j"
			["2000-07-01", "Junior"]
		when "s"
			["1971-07-01", "Senior"]
		when "m50"
			["1961-07-01", "Master"]
		when "m60"
			["1951-07-01", "Master60"]
		when "m70"
			["1941-07-01", "Master70"]
	end
end

# ################################################
# Seed Tasks
# ################################################

desc "Load Archer Seeds (World Only)"
task load_archers: :environment do
	codes = ["rbw", "ruw", "rcw", "rjw", "rsw", "rm50w", "rm60w", "rm70w", "rbm", "rum", "rcm", "rjm", "rsm", "rm50m", "rm60m", "rm70m", "cbw", "cuw", "ccw", "cjw", "csw", "cm50w", "cm60w", "cm70w", "cbm", "cum", "ccm", "cjm", "csm", "cm50m", "cm60m", "cm70m"]
	count = 0
  codes.each do |c|
    count +=1
    Archer.find_or_create_by(
      username: "testuser#{count}", 
      email: "testuser#{count}@example.com", 
      password_digest: "test", 
	  first_name: get_div(c).last, 
      last_name: get_details(c).last, 
      birthdate: get_details(c).first, 
      gender_id: get_gender(c), 
      home_city: get_details(c).last, 
      home_state: get_div(c).first, 
      home_country: "USA", 
	  default_age_class: "", 
	  default_division: get_div(c).last
    )
  end
  Archer.all.each { |a| a.update(password: "test") }
end

desc "Load Score Session Seeds"
task load_score_sessions: :environment do
	# these create an active 2020 World Cup for each Senior Recurve & Compound Archer
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", archer_id: 5, gov_body_id: 1, active: true)
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", archer_id: 13, gov_body_id: 1, active: true)
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", archer_id: 21, gov_body_id: 1, active: true)
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", archer_id: 29, gov_body_id: 1, active: true)

	# these create an inactive 2010 US Nationals for each Junior Recurve & Compound Archer
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 4, gov_body_id: 1, active: false)
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 12, gov_body_id: 1, active: false)
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 20, gov_body_id: 1, active: false)
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 28, gov_body_id: 1, active: false)

	# these are set up for USA Archery when adding that in
	# ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 4, gov_body_id: 2, active: false)
	# ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 12, gov_body_id: 2, active: false)
	# ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 20, gov_body_id: 2, active: false)
	# ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", archer_id: 28, gov_body_id: 2, active: false)
end

desc "Load Qualifying Round Seeds"
task load_qualifying_rounds: :environment do
	# these create a 720 Round for the 2020 World Cup for each Senior Archer
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 5, score_session_id: 1, round_format_id: 4, archer_category_id: 3)
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 13, score_session_id: 2, round_format_id: 4, archer_category_id: 7)
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 21, score_session_id: 3, round_format_id: 4, archer_category_id: 11)
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 29, score_session_id: 4, round_format_id: 4, archer_category_id: 15)

	# these create a 1440 Round for the 2010 US Nationals for each Junior Archer
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 4, score_session_id: 5, round_format_id: 2, archer_category_id: 2)
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 12, score_session_id: 6, round_format_id: 2, archer_category_id: 6)
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 20, score_session_id: 7, round_format_id: 2, archer_category_id: 10)
	Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 28, score_session_id: 8, round_format_id: 2, archer_category_id: 14)
end

# desc "Load Match Round Seeds"
# task load_match_rounds: :environment do
# 	# these need to be revisited after working out Match Round Rules
# 	Round.find_or_create_by(name: "1/16 Match", round_type: "Match", score_method: "Set", rank: "", archer_id: 5, score_session_id: 1, round_format_id: "", archer_category_id: "")
# 	Round.find_or_create_by(name: "1/16 Match", round_type: "Match", score_method: "Set", rank: "", archer_id: 13, score_session_id: 2, round_format_id: "", archer_category_id: "")
# end

desc "Load Qualifying Set Seeds"
task load_qualifying_rsets: :environment do
	# these create both Rsets for each 720 Round for the 2020 World Cup for each Senior Archer
	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 5, score_session_id: 1, round_id: 1, set_end_format_id: 17) #, distance_target_category_id: 259)
	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 5, score_session_id: 1, round_id: 1, set_end_format_id: 18) #, distance_target_category_id: 275)

	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 13, score_session_id: 2, round_id: 2, set_end_format_id: 17) #, distance_target_category_id: 263)
	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 13, score_session_id: 2, round_id: 2, set_end_format_id: 18) #, distance_target_category_id: 279)

	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 21, score_session_id: 3, round_id: 3, set_end_format_id: 17) #, distance_target_category_id: 267)
	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 21, score_session_id: 3, round_id: 3, set_end_format_id: 18) #, distance_target_category_id: 283)

	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 29, score_session_id: 4, round_id: 4, set_end_format_id: 17) #, distance_target_category_id: 271)
	Rset.find_or_create_by(date: "2020-09-01", rank: "", archer_id: 29, score_session_id: 4, round_id: 4, set_end_format_id: 18) #, distance_target_category_id: 287)

	# these create all 4 Rsets for each 1440 Round for the 2010 US Nationals for each Junior Archer
	Rset.find_or_create_by(date: "2010-09-01", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 5, set_end_format_id: 9) #, distance_target_category_id: 130)
	Rset.find_or_create_by(date: "2010-09-02", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 5, set_end_format_id: 10) #, distance_target_category_id: 146)
	Rset.find_or_create_by(date: "2010-09-03", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 5, set_end_format_id: 11) #, distance_target_category_id: 162)
	Rset.find_or_create_by(date: "2010-09-04", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 5, set_end_format_id: 12) #, distance_target_category_id: 178)

	Rset.find_or_create_by(date: "2010-09-01", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 6, set_end_format_id: 9) #, distance_target_category_id: 134)
	Rset.find_or_create_by(date: "2010-09-02", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 6, set_end_format_id: 10) #, distance_target_category_id: 150)
	Rset.find_or_create_by(date: "2010-09-03", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 6, set_end_format_id: 11) #, distance_target_category_id: 166)
	Rset.find_or_create_by(date: "2010-09-04", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 6, set_end_format_id: 12) #, distance_target_category_id: 182)
	
	Rset.find_or_create_by(date: "2010-09-01", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 7, set_end_format_id: 9) #, distance_target_category_id: 138)
	Rset.find_or_create_by(date: "2010-09-02", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 7, set_end_format_id: 10) #, distance_target_category_id: 154)
	Rset.find_or_create_by(date: "2010-09-03", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 7, set_end_format_id: 11) #, distance_target_category_id: 170)
	Rset.find_or_create_by(date: "2010-09-04", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 7, set_end_format_id: 12) #, distance_target_category_id: 186)
	
	Rset.find_or_create_by(date: "2010-09-01", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 8, set_end_format_id: 9) #, distance_target_category_id: 142)
	Rset.find_or_create_by(date: "2010-09-02", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 8, set_end_format_id: 10) #, distance_target_category_id: 158)
	Rset.find_or_create_by(date: "2010-09-03", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 8, set_end_format_id: 11) #, distance_target_category_id: 174)
	Rset.find_or_create_by(date: "2010-09-04", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 8, set_end_format_id: 12) #, distance_target_category_id: 190)
end

# desc "Load Match Set Seeds"
# task load_match_rsets: :environment do
# 	# these need to be revisited after working out Match Round Rules
# 	Rset.create(date: "2020-09-01", rank: "", archer_id: 5, score_session_id: 1, round_id: 1, set_end_format_id: 17)
# end

desc "Load End Seeds"
task load_ends: :environment do
	Rset.all.each do |rset|
		if rset.set_end_format_id == 17 || rset.set_end_format_id == 18 || rset.set_end_format_id == 9 || rset.set_end_format_id == 10
			6.times { End.find_or_create_by(set_score: "", archer_id: rset.archer.id, score_session_id: rset.score_session.id, round_id: rset.round.id, rset_id: rset.id) }
		elsif rset.set_end_format_id == 11 || rset.set_end_format_id == 12 
			12.times { End.find_or_create_by(set_score: "", archer_id: rset.archer.id, score_session_id: rset.score_session.id, round_id: rset.round.id, rset_id: rset.id) }
		end
	end
end

desc "Load Shot Seeds"
task load_shots: :environment do
	# have to use create or will only create one shot for each End, since doesn't any has_many assoc, actual id for shot doesn't matter
	Shot.destroy_all
	
	End.all.each do |endd|
		if endd.rset.set_end_format_id == 17 || endd.rset.set_end_format_id == 18
			endd.shots_per_end.times { Shot.create(score_entry: "", archer_id: endd.archer.id, score_session_id: endd.score_session.id, round_id: endd.round.id, rset_id: endd.rset.id, end_id: endd.id) }
		elsif endd.rset.set_end_format_id == 9 || endd.rset.set_end_format_id == 10 || endd.rset.set_end_format_id == 11 || endd.rset.set_end_format_id == 12
			endd.shots_per_end.times { Shot.create(score_entry: "X", archer_id: endd.archer.id, score_session_id: endd.score_session.id, round_id: endd.round.id, rset_id: endd.rset.id, end_id: endd.id) }
		end
	end
end