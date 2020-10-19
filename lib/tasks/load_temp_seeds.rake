# desc "just checking"
# task check_tasks: :environment do
# 	puts "hello world"
# end

def get_gender(code)
	if code.last == "w"
		"Female"
	else
		"Male"
	end
end

def get_div(code)
	if code.first == "c"
		"CO"
	else
		"RI"
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

desc "Load Archer Seeds"
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
      home_state: get_div(c), 
      home_country: "USA", 
      default_age_class: ""
    )
  end
end

desc "Load Score Session Seeds"
task load_score_sessions: :environment do
end

desc "Load Round Seeds"
task load_rounds: :environment do
end

desc "Load Shot Seeds"
task load_shots: :environment do
end