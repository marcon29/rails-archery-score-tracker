require 'rails_helper'

RSpec.describe Round, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
            name: "2020 World Cup - Double 1440 Round", 
            round_type: "Qualifying", 
            score_method: "Points", 
            rank: "1st", 
            archer_id: 1, 
            score_session_id: 1, 
            round_format_id: 1
        }
    }

    let(:test_round) {
        Round.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {round_type: "Qualifying", score_method: "Points", archer_id: 1, score_session_id: 1, round_format_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "2020 World Cup - Double 1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 1, score_session_id: 1, round_format_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", round_type: "Match", score_method: "Set", rank: "Win", archer_id: 1, score_session_id: 1, round_format_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", round_type: "", score_method: "", rank: "", archer_id: 1, score_session_id: 1, round_format_id: 1}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"#{valid_score_session.name} - #{valid_round_format.name}"}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_round_type_message) {"You must choose a round type."}
    let(:missing_score_method_message) {"You must choose a score method."}
    let(:inclusion_rank_message) {'Enter only a number above 0, "W" or "L".'}
    

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            before_round
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Round.all.count).to eq(0)

                expect(test_round).to be_valid
                expect(Round.all.count).to eq(1)

                expect(test_round.name).to eq(test_all[:name])
                expect(test_round.round_type).to eq(test_all[:round_type])
                expect(test_round.score_method).to eq(test_all[:score_method])
                expect(test_round.rank).to eq(test_all[:rank])
            end
            
            it "given only required attributes" do
                expect(Round.all.count).to eq(0)
                round = Round.create(test_req)

                expect(round).to be_valid
                expect(Round.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(round.round_type).to eq(test_req[:round_type])
                expect(round.score_method).to eq(test_req[:score_method])

                # not req input tests (name auto-asigned from missing)
                expect(round.name).to eq(assigned_name)
                expect(round.rank).to be_nil
            end

            it "name is duplicated but for different ScoreSessions" do
                # need two round_formats
                second_round_format = Format::RoundFormat.create(name: "720 Round", num_sets: 1, discipline_id: 1, user_edit: false)

                # need two score_sessions
                second_score_sesion = ScoreSession.create(name: "2010 US Nationals", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2010-09-01", end_date: "2010-09-05", rank: "1st", active: true, archer_id: 1, gov_body_id: 1)
                expect(ScoreSession.all.count).to eq(2)
                expect(Round.all.count).to eq(0)

                # gives me 2 rounds in valid_score_session
                valid_round
                test_round
                expect(Round.all.count).to eq(2)
                
                # gives me 1 round in second_score_sesion
                update[:score_session_id] = 2
                third_round = Round.create(update)
                expect(Round.all.count).to eq(3)

                # test duped name from valid_round_format but in second_round_format
                duplicate[:score_session_id] = 2
                duplicate[:round_format_id] = 2
                round = Round.create(duplicate)

                expect(round).to be_valid
                expect(Round.all.count).to eq(4)

                expect(round.name).to eq("#{round.score_session.name} - #{round.round_format.name}")
                expect(round.round_type).to eq(duplicate[:round_type])
                expect(round.score_method).to eq(duplicate[:score_method])
                expect(round.rank).to eq(duplicate[:rank])
            end

            it "updating all attributes" do
                test_round.update(update)
                
                expect(test_round).to be_valid
                
                # req input tests (should have value in update)
                expect(test_round.round_type).to eq(update[:round_type])
                expect(test_round.score_method).to eq(update[:score_method])
                expect(test_round.rank).to eq(update[:rank])

                # user_edit auto-asigned from blank
                expect(test_round.name).to eq(assigned_name)
            end

            it "all associated objects have the same parents" do
                expect(test_round.check_associations.count).to eq(1)
                expect(test_round.check_associations).not_to include(false)
                expect(test_round).to be_valid
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                round = Round.create(blank)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(0)

                expect(round.name).to eq(assigned_name)
                expect(round.errors.messages[:round_type]).to include(missing_round_type_message)
                expect(round.errors.messages[:score_method]).to include(missing_score_method_message)
                expect(round.rank).to be_blank
            end

            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_round
                expect(Round.all.count).to eq(1)
                round = Round.create(duplicate)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(1)
                expect(round.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "round type is outside allowable inputs" do
                duplicate[:round_type] = "bad type"
                duplicate[:score_method] = "bad method"
                round = Round.create(duplicate)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(0)
                expect(round.errors.messages[:round_type]).to include(default_inclusion_message)
                expect(round.errors.messages[:score_method]).to include(default_inclusion_message)
            end

            it "rank is outside allowable inputs" do
                bad_scenarios = ["0", "000", "00text", "00st", "-1", "first", "winner", "loser"]

                bad_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    round = Round.create(duplicate)
                    expect(round).to be_invalid
                    expect(Round.all.count).to eq(0)
                    
                    expect(round.errors.messages[:rank]).to include(inclusion_rank_message)
                end
            end

            it "an associated object has a different parent" do
                before_archer

                second_archer = Archer.create(
                    username: "testuser", 
                    email: "testuser@example.com", 
                    password: "test", 
                    first_name: "Test", 
                    last_name: "Tuser", 
                    birthdate: "1980-07-01", 
                    gender: "Male", 
                    home_city: "Denver", 
                    home_state: "CO", 
                    home_country: "USA", 
                    default_age_class: "Senior", 
                    default_division: "Recurve"
                )
                test_round.update(archer: second_archer)

                expect(test_round).to be_invalid
                expect(test_round.errors.messages).to be_present
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            before_round
        end

        describe "belongs to an Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_round.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                update[:archer_id] = ""
                check_round = assoc_archer.rounds.create(update)
                
                expect(check_round.archer).to eq(assoc_archer)
                expect(check_round.archer.username).to include(assoc_archer.username)
            end
        end

        describe "belongs to a ScoreSession and" do
            it "can find an associated object" do
                assoc_score_session = valid_score_session
                expect(test_round.score_session).to eq(assoc_score_session)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_score_session = valid_score_session
                update[:score_session_id] = ""
                check_round = assoc_score_session.rounds.create(update)
                
                expect(check_round.score_session).to eq(assoc_score_session)
                expect(check_round.score_session.name).to include(assoc_score_session.name)
            end
        end

        describe "has many Rsets and" do
            it "can find an associated object" do
                expect(valid_round.rsets).to include(valid_rset)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round = Round.create(duplicate)

                check_rset_attrs = {date: "2020-09-01", archer: valid_archer, score_session: valid_score_session, set_end_format: valid_set_end_format}
                check_rset = round.rsets.create(check_rset_attrs)
                
                expect(round.rsets).to include(check_rset)
                expect(round.rsets.last.name).to eq(check_rset.name)
            end
        end

        describe "has many Ends and" do
            before(:each) do
                before_end
            end

            it "can find an associated object" do
                expect(valid_round.ends).to include(valid_end)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round = Round.create(duplicate)

                check_end_attrs = {set_score: 2, archer_id: 1, score_session_id: 1, rset_id: 1}
                check_end = round.ends.create(check_end_attrs)
                
                expect(round.ends).to include(check_end)
                expect(round.ends.last.number).to eq(check_end.number)
            end
        end

        describe "has many Shots and" do
            before(:each) do
                before_shot
            end

            it "can find an associated object" do
                expect(valid_round.shots).to include(valid_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round = Round.create(duplicate)

                check_shot_attrs = {score_entry: "5", archer_id: 1, score_session_id: 1, rset_id: 1, end_id: 1}
                check_shot = round.shots.create(check_shot_attrs)
                
                expect(round.shots).to include(check_shot)
                expect(round.shots.last.score_entry).to eq(check_shot.score_entry)
            end
        end

        describe "belongs to a RoundFormat and" do
            it "can find an associated object" do
                assoc_round_format = valid_round_format
                expect(test_round.round_format).to eq(assoc_round_format)
            end
        end

        describe "sectioning off for Organization concern" do
            it "has one ArcherCategory" do
                pending "need to create associated models and add associations"
                expect(test_round.archer_category).to eq(valid_category)
            end

            it "has one Discipline" do
                pending "need to create associated models and add associations"
                expect(test_round.discipline).to eq(valid_discipline)
            end

            it "has one Division" do
                pending "need to create associated models and add associations"
                expect(test_round.division).to eq(valid_division)
            end

            it "has one Age Class" do
                pending "need to create associated models and add associations"
                expect(test_round.age_class).to eq(valid_age_class)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can calculate the total score for a round" do
            before_shot
            Round.destroy_all
            Rset.destroy_all
            End.destroy_all
            Shot.destroy_all

            round = Round.create(test_req)
            expect(Round.all.count).to eq(1)
            expect(Rset.all.count).to eq(0)
            expect(End.all.count).to eq(0)
            expect(Shot.all.count).to eq(0)

            second_set_end_format = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, user_edit: false, round_format: valid_round_format)
            first_rset = Rset.create(date: "2020-09-01", archer_id: 1, score_session_id: 1, round: round, set_end_format: valid_set_end_format)
            second_rset = Rset.create(date: "2020-09-01", archer_id: 1, score_session_id: 1, round: round, set_end_format: second_set_end_format)
            expect(Rset.all.count).to eq(2)
            expect(round.rsets.count).to eq(2)
            
            # set up first Rset
            first_end = End.create(archer_id: 1, score_session_id: 1, round: round, rset: first_rset)
            second_end = End.create(archer_id: 1, score_session_id: 1, round: round, rset: first_rset)
            expect(End.all.count).to eq(2)
            expect(first_rset.ends.count).to eq(2)
            expect(round.ends.count).to eq(2)

            Shot.create(score_entry: "X", archer_id: 1, score_session_id: 1, round: round, rset: first_rset, end: first_end)
            Shot.create(score_entry: "10", archer_id: 1, score_session_id: 1, round: round, rset: first_rset, end: first_end)
            Shot.create(score_entry: "M", archer_id: 1, score_session_id: 1, round: round, rset: first_rset, end: first_end)
            Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round: round, rset: first_rset, end: second_end)
            Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round: round, rset: first_rset, end: second_end)
            Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round: round, rset: first_rset, end: second_end)
            expect(Shot.all.count).to eq(6)
            expect(first_rset.shots.count).to eq(6)
            expect(round.shots.count).to eq(6)

            # set up second Rset
            third_end = End.create(archer_id: 1, score_session_id: 1, round: round, rset: second_rset)
            fourth_end = End.create(archer_id: 1, score_session_id: 1, round: round, rset: second_rset)
            expect(End.all.count).to eq(4)
            expect(second_rset.ends.count).to eq(2)
            expect(round.ends.count).to eq(4)

            Shot.create(score_entry: "X", archer_id: 1, score_session_id: 1, round: round, rset: second_rset, end: third_end)
            Shot.create(score_entry: "10", archer_id: 1, score_session_id: 1, round: round, rset: second_rset, end: third_end)
            Shot.create(score_entry: "M", archer_id: 1, score_session_id: 1, round: round, rset: second_rset, end: third_end)
            Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round: round, rset: second_rset, end: fourth_end)
            Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round: round, rset: second_rset, end: fourth_end)
            Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round: round, rset: second_rset, end: fourth_end)
            expect(Shot.all.count).to eq(12)
            expect(second_rset.shots.count).to eq(6)
            expect(round.shots.count).to eq(12)

            expect(round.score).to eq(70)
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_round).to be_valid
        end
    end
end
