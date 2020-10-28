
# ################################################
# these should go in regular seeds
# ################################################
desc "Load RoundFormat Seeds"
task load_round_formats: :environment do
	r1440 = RoundFormat.create(name: "1440 Round", num_sets: 4)
	r720 = RoundFormat.create(name: "720 Round", num_sets: 2)
end

desc "Load SetEndFormat Seeds"
task set_end_formats: :environment do
	r1440 = RoundFormat.find_by(name: "1440 Round")
	r720 = RoundFormat.find_by(name: "720 Round")

	r1440.set_end_formats.create(num_ends: 6, shots_per_end: 6, round_format_id: 1)
	r1440.set_end_formats.create(num_ends: 6, shots_per_end: 6, round_format_id: 1)
	r1440.set_end_formats.create(num_ends: 12, shots_per_end: 3, round_format_id: 1)
	r1440.set_end_formats.create(num_ends: 12, shots_per_end: 3, round_format_id: 1)
	r720.set_end_formats.create(num_ends: 6, shots_per_end: 6, round_format_id: 2)
	r720.set_end_formats.create(num_ends: 6, shots_per_end: 6, round_format_id: 2)
end



# ################################################
# original seeds
# ################################################
def get_gender(code)
	if code.last == "w"
		"Female"
	else
		"Male"
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
      first_name: "test#{count}", 
      last_name: "user#{count}", 
      birthdate: get_details(c).first, 
      gender: get_gender(c), 
      home_city: get_details(c).last, 
      home_state: get_div(c).first, 
      home_country: "USA", 
	  default_age_class: "", 
	  default_division: get_div(c).last
    )
  end
end

desc "Load Score Session Seeds"
task load_score_sessions: :environment do
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", active: true, archer_id: 5)
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", active: true, archer_id: 13)
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", active: true, archer_id: 21)
	ScoreSession.find_or_create_by(name: "2020 World Cup", score_session_type: "Tournament", city: "Chula Vista", state: "CA", country: "USA", start_date: "2020-09-01", end_date: "", rank: "", active: true, archer_id: 29)

	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", active: false, archer_id: 4)
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", active: false, archer_id: 12)
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", active: false, archer_id: 20)
	ScoreSession.find_or_create_by(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", active: false, archer_id: 28)
end

desc "Load Round Seeds"
task load_rounds: :environment do
	Round.find_or_create_by(name: "720 Round", round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 5, score_session_id: 1)
	Round.find_or_create_by(name: "720 Round", round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 13, score_session_id: 2)
	Round.find_or_create_by(name: "720 Round", round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 21, score_session_id: 3)
	Round.find_or_create_by(name: "720 Round", round_type: "Qualifying", score_method: "Points", rank: "", archer_id: 29, score_session_id: 4)

	Round.find_or_create_by(name: "1/16 Match", round_type: "Match", score_method: "Set", rank: "", archer_id: 5, score_session_id: 1)
	Round.find_or_create_by(name: "1/16 Match", round_type: "Match", score_method: "Set", rank: "", archer_id: 13, score_session_id: 2)

	Round.find_or_create_by(name: "1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 4, score_session_id: 5)
	Round.find_or_create_by(name: "1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 12, score_session_id: 6)
	Round.find_or_create_by(name: "1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 20, score_session_id: 7)
	Round.find_or_create_by(name: "1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 28, score_session_id: 8)
end

desc "Load Set Seeds"
task load_rsets: :environment do
	Rset.destroy_all
	Rset.create(date: "2020-09-01", rank: "1st", archer_id: 5, score_session_id: 1, round_id: 1)
	Rset.create(date: "2020-09-01", rank: "1st", archer_id: 13, score_session_id: 2, round_id: 2)
	Rset.create(date: "2020-09-01", rank: "1st", archer_id: 21, score_session_id: 3, round_id: 3)
	Rset.create(date: "2020-09-01", rank: "1st", archer_id: 29, score_session_id: 4, round_id: 4)


	Rset.create(date: "2010-09-01", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 7)
	Rset.create(date: "2010-09-01", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 8)
	Rset.create(date: "2010-09-01", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 9)
	Rset.create(date: "2010-09-01", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 10)

	Rset.create(date: "2010-09-02", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 7)
	Rset.create(date: "2010-09-02", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 8)
	Rset.create(date: "2010-09-02", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 9)
	Rset.create(date: "2010-09-02", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 10)

	Rset.create(date: "2010-09-03", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 7)
	Rset.create(date: "2010-09-03", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 8)
	Rset.create(date: "2010-09-03", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 9)
	Rset.create(date: "2010-09-03", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 10)

	Rset.create(date: "2010-09-04", rank: "1st", archer_id: 4, score_session_id: 5, round_id: 7)
	Rset.create(date: "2010-09-04", rank: "1st", archer_id: 12, score_session_id: 6, round_id: 8)
	Rset.create(date: "2010-09-04", rank: "1st", archer_id: 20, score_session_id: 7, round_id: 9)
	Rset.create(date: "2010-09-04", rank: "1st", archer_id: 28, score_session_id: 8, round_id: 10)
end

desc "Load End Seeds"
task load_shots: :environment do
end

desc "Load Shot Seeds"
task load_shots: :environment do
end