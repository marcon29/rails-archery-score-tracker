require 'rails_helper'

RSpec.describe ScoreSession, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
        name: "2010 World Cup", 
        score_session_type: "Tournament", 
        city: "Oxford", 
        state: "OH", 
        country: "USA", 
        start_date: "2010-09-01", 
        end_date: "2010-09-05", 
        rank: "1st", 
        active: true, 
        archer_id: 1
        }
    }
    
    let(:test_score_session) {
        ScoreSession.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {name: "2010 World Cup", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", archer_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "2010 World Cup", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", active: true, archer_id: 1}
    }
    
    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "2000 Pan Am Trials", score_session_type: "Competition", city: "Chula Vista", state: "CA", country: "CAN", start_date: "2000-09-01", end_date: "", rank: "3rd", active: false, archer_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", score_session_type: "", city: "", state: "", country: "", start_date: "", end_date: "", rank: "", active: "", archer_id: 1}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    # end_date is assigned but only if empty, so it varies - easier to put in data source for tests
    let(:default_active) {true}
    
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a name."}
    let(:missing_session_type_message) {"You must choose a score session type."}
    let(:missing_city_message) {"You must enter a city."}
    let(:missing_state_message) {"You must enter a state."}
    let(:missing_country_message) {"You must enter a country."}
    let(:missing_start_date_message) {"You must choose a start date."}
    let(:duplicate_name_message) {"That name is already taken."}
    let(:inclusion_rank_message) {'Enter only a number above 0, "W" or "L".'}
    

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances" do
        before(:each) do
            before_score_session
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(ScoreSession.all.count).to eq(0)

                expect(test_score_session).to be_valid
                expect(ScoreSession.all.count).to eq(1)
                
                expect(test_score_session.name).to eq(test_all[:name])
                expect(test_score_session.score_session_type).to eq(test_all[:score_session_type])
                expect(test_score_session.city).to eq(test_all[:city])
                expect(test_score_session.state).to eq(test_all[:state])
                expect(test_score_session.country).to eq(test_all[:country])
                expect(test_score_session.start_date).to eq(test_all[:start_date].to_date)
                expect(test_score_session.end_date).to eq(test_all[:end_date].to_date)
                expect(test_score_session.rank).to eq(test_all[:rank])
                expect(test_score_session.active).to eq(test_all[:active])
            end
            
            it "given only required attributes" do
                expect(ScoreSession.all.count).to eq(0)
                score_session = ScoreSession.create(test_req)

                expect(score_session).to be_valid
                expect(ScoreSession.all.count).to eq(1)
                
                # req input tests (should have value in test_req)
                expect(score_session.name).to eq(test_req[:name])
                expect(score_session.score_session_type).to eq(test_req[:score_session_type])
                expect(score_session.city).to eq(test_req[:city])
                expect(score_session.state).to eq(test_req[:state])
                expect(score_session.country).to eq(test_req[:country])
                expect(score_session.start_date).to eq(test_req[:start_date].to_date)
                expect(score_session.end_date).to eq(test_req[:start_date].to_date)
                expect(score_session.rank).to eq(test_req[:rank])
                
                # not req input tests (active and end date auto-asigned from missing)
                expect(score_session.end_date).to eq(test_req[:start_date].to_date)
                expect(score_session.active).to eq(default_active)
            end

            it "name is duplicated but for different ScoreSessions" do
                # need second Archer
                second_archer = Archer.create(username: "testuser", email: "testuser@example.com", password: "test", first_name: "Test", last_name: "Tuser", birthdate: "1980-07-01", gender: "Male", default_division: "Recurve")
                expect(Archer.all.count).to eq(2)
                expect(ScoreSession.all.count).to eq(0)

                # gives me 2 score_sessions in valid_archer
                valid_score_session
                test_score_session
                expect(ScoreSession.all.count).to eq(2)
                
                # gives me score_session with same name as test_score_session but in second_archer
                test_req[:archer_id] = 2
                score_session = ScoreSession.create(test_req)

                expect(score_session.name).to eq(test_score_session.name)
                expect(score_session).to be_valid
                expect(ScoreSession.all.count).to eq(3)

                expect(score_session.name).to eq(test_req[:name])
                expect(score_session.score_session_type).to eq(test_req[:score_session_type])
                expect(score_session.city).to eq(test_req[:city])
                expect(score_session.state).to eq(test_req[:state])
                expect(score_session.country).to eq(test_req[:country])
                expect(score_session.start_date).to eq(test_req[:start_date].to_date)
                expect(score_session.end_date).to eq(test_req[:start_date].to_date)
                expect(score_session.rank).to eq(test_req[:rank])
                expect(score_session.active).to eq(default_active)
            end
            
            it "updating all attributes" do
                test_score_session.update(update)
                
                # req input tests (should have value in update)
                expect(test_score_session).to be_valid
                expect(test_score_session.name).to eq(update[:name])
                expect(test_score_session.score_session_type).to eq(update[:score_session_type])
                expect(test_score_session.city).to eq(update[:city])
                expect(test_score_session.state).to eq(update[:state])
                expect(test_score_session.country).to eq(update[:country])
                expect(test_score_session.start_date).to eq(update[:start_date].to_date)
                expect(test_score_session.rank).to eq(update[:rank])
                expect(test_score_session.active).to eq(update[:active])

                # not req input tests (active auto-asigned from blank)
                expect(test_score_session.end_date).to eq(update[:start_date].to_date)
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                score_session = ScoreSession.create(blank)

                expect(score_session).to be_invalid
                expect(ScoreSession.all.count).to eq(0)

                expect(score_session.errors.messages[:name]).to include(missing_name_message)
                expect(score_session.errors.messages[:score_session_type]).to include(missing_session_type_message)
                expect(score_session.errors.messages[:city]).to include(missing_city_message)
                expect(score_session.errors.messages[:state]).to include(missing_state_message)
                expect(score_session.errors.messages[:country]).to include(missing_country_message)
                expect(score_session.errors.messages[:start_date]).to include(missing_start_date_message)
            end

            it "unique attributes are duplicated" do
                test_score_session
                expect(ScoreSession.all.count).to eq(1)
                score_session = ScoreSession.create(duplicate)

                expect(score_session).to be_invalid
                expect(ScoreSession.all.count).to eq(1)
                expect(score_session.errors.messages[:name]).to include(duplicate_name_message)
            end

            it "score session type is outside allowable inputs" do
                duplicate[:score_session_type] = "bad data"
                score_session = ScoreSession.create(duplicate)

                expect(score_session).to be_invalid
                expect(ScoreSession.all.count).to eq(0)
                expect(score_session.errors.messages[:score_session_type]).to include(default_inclusion_message)
            end

            it "rank is outside allowable inputs" do
                bad_scenarios = ["0", "000", "00text", "00st", "-1", "first", "winner", "loser"]

                bad_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session).to be_invalid
                    expect(ScoreSession.all.count).to eq(0)
                    expect(score_session.errors.messages[:rank]).to include(inclusion_rank_message)
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            valid_archer
            valid_set_end_format
            valid_target
        end

        describe "belongs to an Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_score_session.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                update[:archer_id] = ""
                check_score_session = assoc_archer.score_sessions.create(update)
                
                expect(check_score_session.archer).to eq(assoc_archer)
                expect(check_score_session.archer.username).to include(assoc_archer.username)
            end
        end

        describe "has many Rounds and" do
            it "can find an associated object" do
                expect(valid_score_session.rounds).to include(valid_round)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                score_session = ScoreSession.create(duplicate)

                check_round_attrs = {round_type: "Qualifying", score_method: "Points", rank: "1st", archer: valid_archer, round_format: valid_round_format}
                check_round = score_session.rounds.create(check_round_attrs)
                
                expect(score_session.rounds).to include(check_round)
                expect(score_session.rounds.last.name).to eq(check_round.name)
            end
        end
    
        describe "has many Rsets and" do
            it "can find an associated object" do
                expect(valid_score_session.rsets).to include(valid_rset)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                score_session = ScoreSession.create(duplicate)
                
                check_rset_attrs = {date: "2020-09-01", archer: valid_archer, round: valid_round, set_end_format: valid_set_end_format}
                check_rset = score_session.rsets.create(check_rset_attrs)
                
                expect(score_session.rsets).to include(check_rset)
                expect(score_session.rsets.last.name).to eq(check_rset.name)
            end
        end

        describe "has many Ends and" do
            before(:each) do
                before_end
            end

            it "can find an associated object" do
                expect(valid_score_session.ends).to include(valid_end)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                score_session = ScoreSession.create(duplicate)

                check_end_attrs = {set_score: 2, archer_id: 1, round_id: 1, rset_id: 1}
                check_end = score_session.ends.create(check_end_attrs)
                
                expect(score_session.ends).to include(check_end)
                expect(score_session.ends.last.number).to eq(check_end.number)
            end
        end

        describe "has many Shots and" do
            before(:each) do
                before_shot
            end

            it "can find an associated object" do
                expect(valid_score_session.shots).to include(valid_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                score_session = ScoreSession.create(duplicate)
                
                check_shot_attrs = {score_entry: "5", archer_id: 1, round_id: 1, rset_id: 1, end_id: 1}
                check_shot = score_session.shots.create(check_shot_attrs)
                
                expect(score_session.shots).to include(check_shot)
                expect(score_session.shots.last.score_entry).to eq(check_shot.score_entry)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the score sessions's name with correct capitalization" do
            duplicate[:name] = "2020 world cup"
            score_session = ScoreSession.create(duplicate)
            expect(score_session.name).to eq("2020 World Cup")
        end

        describe "can assign and format the rank from any good input for" do
            it "numbers to end in 'st'" do
                st_scenarios = ["1", "21", "0021", "1ND", "21ST", "0021st"]

                st_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session.rank).to eq("#{test_value.to_i.to_s}st")
                end
            end
                
            it "numbers to end in 'nd'" do
                nd_scenarios = ["2", "22","0022", "2ST", "22ND", "0022nd"]
                
                nd_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session.rank).to eq("#{test_value.to_i.to_s}nd")
                end
            end 
            
            it "numbers to end in 'rd'" do
                rd_scenarios = ["3", "23", "0023", "3ST", "23RD", "0023rd"]
                
                rd_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session.rank).to eq("#{test_value.to_i.to_s}rd")
                end
            end
                            
            it "numbers to end in 'th'" do
                th_scenarios = ["4", "24", "0024", "4ST", "24TH", "0024th", "11", "0011"]
                
                th_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session.rank).to eq("#{test_value.to_i.to_s}th")
                end
            end

            it "variations of 'Win'" do
                win_scenarios = ["W", "w", "Win", "win", "Won", "won"]

                win_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session.rank).to eq("Win")
                end
            end

            it "variations of 'Loss'" do
                lose_scenarios = ["L", "l", "Loss", "loss", "Lost", "lost"]

                lose_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session.rank).to eq("Loss")
                end
            end
        end
    
        it "helpers TBD" do
            pending "add as needed"
            expect(test_score_session).to be_valid
        end
    end
end
