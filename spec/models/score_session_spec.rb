require 'rails_helper'

RSpec.describe ScoreSession, type: :model do
    # add attrs (must be in hash) for all regular valid instances of ScoreSession
        # one with all attrs defined and one with only required attrs defined
        # doing this separately makes writing the expect statments easier
    let(:valid_all) {
        {
        name: "2020 World Cup", 
        score_session_type: "Tournament", 
        city: "Oxford", 
        state: "OH", 
        country: "USA", 
        start_date: "2020-09-01", 
        end_date: "2020-09-05", 
        rank: "1st", 
        active: true
        }
    }

    # create the main valid test instances, using the valid_all attrs (not persisted until called)
        # only add multiple instantiations if need multiple instances at the same time for testing
        # if just need to adjust attr values, use the attr sets below
    let(:test_score_session) {
        ScoreSession.create(valid_all)
    }
    
    #  all instances of AssocModels needed for testing associations (not persisted until called)
    let(:assoc_archer) {
        Archer.create(
            username: "testuser", 
            email: "testuser@example.com", 
            password: "test", 
            first_name: "Test", 
            last_name: "User", 
            birthdate: "1980-07-01", 
            gender: "Male", 
            home_city: "Denver", 
            home_state: "CO", 
            home_country: "USA", 
            default_age_class: "Senior"
        )
    }
    
    let(:test_round) {
        Round.create(name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4, user_edit: false)
    }

    let(:assoc_round_set) {
        RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
    }

    # let(:assoc_shot) {
    #   Shot.create()
    # }

    let(:assoc_category_senior) {
        ArcherCategory.create(
        cat_code: "WA-RM", 
        gov_body: "World Archery", 
        cat_division: "Recurve", 
        cat_age_class: "Senior", 
        min_age: 21, 
        max_age: 49, 
        open_to_younger: true, 
        open_to_older: true, 
        cat_gender: "Male"
        )
    }

    let(:assoc_target) {
        Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
    }

    let(:assoc_dist_targ) {
        DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
    }

    # add the following attr sets if need active and inactive at same time for testing
    # let(:valid_inactive) {
    #     {name: "2000 World Cup", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2000-09-01", end_date: "2000-09-05", rank: "1st", active: false}
    # }

    # remove any non-required atts, and auto-assign (not auto_format) attrs, all should be formatted correctly already
    let(:valid_req) {
        {name: "2020 World Cup", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2020-09-01"}
    }

    # exact duplicate of valid_all - use as whole for testing unique values, use for testing specific atttrs (bad inclusion, bad format, etc.)
    let(:duplicate) {
        {name: "2020 World Cup", score_session_type: "Tournament", city: "Oxford", state: "OH", country: "USA", start_date: "2020-09-01", end_date: "2020-09-05", rank: "1st", active: true}
    }
    
    # start w/ valid_all, change all values, make any auto-assign blank (don't delete)
    let(:update) {
        {name: "2010 Pan Am Trials", score_session_type: "Competition", city: "Chula Vista", state: "CA", country: "USA", start_date: "2010-09-01", end_date: "", rank: "3rd", active: false}
    }

    # every attr blank
    let(:blank) {
        {name: "", score_session_type: "", city: "", state: "", country: "", start_date: "", end_date: "", rank: "", active: ""}
    }
  
    # add the following default error messages for different validation failures (delete any unnecessary for model)
    let(:default_missing_message) {"can't be blank"}
    let(:default_duplicate_message) {"has already been taken"}
    let(:default_inclusion_message) {"is not included in the list"}
    let(:default_number_message) {"is not a number"}
    let(:default_format_message) {"is invalid"}

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances" do
        describe "valid with all required and unrequired input data" do
            it "instance is valid with all attributes" do
                expect(ScoreSession.all.count).to eq(0)

                expect(test_score_session).to be_valid
                expect(ScoreSession.all.count).to eq(1)
                
                expect(test_score_session.name).to eq(valid_all[:name])
                expect(test_score_session.score_session_type).to eq(valid_all[:score_session_type])
                expect(test_score_session.city).to eq(valid_all[:city])
                expect(test_score_session.state).to eq(valid_all[:state])
                expect(test_score_session.country).to eq(valid_all[:country])
                expect(test_score_session.start_date).to eq(valid_all[:start_date].to_date)
                expect(test_score_session.end_date).to eq(valid_all[:end_date].to_date)
                expect(test_score_session.rank).to eq(valid_all[:rank])
                expect(test_score_session.active).to eq(valid_all[:active])
            end
            
            it "instance is valid with only required attributes, auto-assigns end date and active status" do
                expect(ScoreSession.all.count).to eq(0)
                score_session = ScoreSession.create(valid_req)

                expect(score_session).to be_valid
                expect(ScoreSession.all.count).to eq(1)
                
                # req input tests
                expect(score_session.name).to eq(valid_req[:name])
                expect(score_session.score_session_type).to eq(valid_req[:score_session_type])
                expect(score_session.city).to eq(valid_req[:city])
                expect(score_session.state).to eq(valid_req[:state])
                expect(score_session.country).to eq(valid_req[:country])
                expect(score_session.start_date).to eq(valid_req[:start_date].to_date)
                expect(score_session.end_date).to eq(valid_req[:start_date].to_date)
                
                # not req input tests (active and end date auto-asigned from missing)
                expect(score_session.end_date).to eq(valid_req[:start_date].to_date)
                expect(score_session.rank).to eq(valid_req[:rank])
                expect(score_session.active).to eq(true)
            end

            it "instance is valid when updating all attrs, re-assigns end date if value deleted" do
                test_score_session.update(update)
                
                expect(test_score_session).to be_valid
                expect(test_score_session.name).to eq(update[:name])
                expect(test_score_session.score_session_type).to eq(update[:score_session_type])
                expect(test_score_session.city).to eq(update[:city])
                expect(test_score_session.state).to eq(update[:state])
                expect(test_score_session.country).to eq(update[:country])
                expect(test_score_session.start_date).to eq(update[:start_date].to_date)
                expect(test_score_session.rank).to eq(update[:rank])
                expect(test_score_session.active).to eq(update[:active])

                # end date auto-asigned from blank
                expect(test_score_session.end_date).to eq(update[:start_date].to_date)
            end
        end

        describe "invalid if input data is missing or bad" do
            it "is invalid without required attributes and has correct error message" do
                score_session = ScoreSession.create(blank)

                expect(score_session).to be_invalid
                expect(ScoreSession.all.count).to eq(0)
                expect(score_session.errors.messages[:name]).to include("You must enter a name.")
                expect(score_session.errors.messages[:score_session_type]).to include("You must choose a score session type.")
                expect(score_session.errors.messages[:city]).to include("You must enter a city.")
                expect(score_session.errors.messages[:state]).to include("You must enter a state.")
                expect(score_session.errors.messages[:country]).to include("You must enter a country.")
                expect(score_session.errors.messages[:start_date]).to include("You must choose a start date.")
            end

            it "is invalid when unique attributes are duplicated and has correct error message" do
                test_score_session
                expect(ScoreSession.all.count).to eq(1)
                score_session = ScoreSession.create(duplicate)

                expect(score_session).to be_invalid
                expect(ScoreSession.all.count).to eq(1)
                expect(score_session.errors.messages[:name]).to include("That name is already taken.")
            end

            it "is invalid if score session not included in corresponding selection list and has correct error message" do
                duplicate[:score_session_type] = "bad data"
                score_session = ScoreSession.create(duplicate)

                expect(score_session).to be_invalid
                expect(ScoreSession.all.count).to eq(0)
                expect(score_session.errors.messages[:score_session_type]).to include(default_inclusion_message)
            end

            it "is invalid if rank is not included in corresponding selection list and has correct error message" do
                bad_scenarios = ["0", "000", "00text", "00st", "-1", "first", "winner", "loser"]

                bad_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    score_session = ScoreSession.create(duplicate)
                    expect(score_session).to be_invalid
                    expect(ScoreSession.all.count).to eq(0)
                    expect(score_session.errors.messages[:rank]).to include('Enter only a number above 0, "W" or "L".')
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load all AssocModels that must be in DB for tests to work
        end

        it "has one Archers" do
            pending "need to add create associated models and add associations"
            expect(test_score_session.archer).to eq(assoc_archer)
        end
      
        it "has many Rounds" do
            pending "need to add create associated models and add associations"
            expect(test_score_session.rounds).to include(assoc_round)
        end
    
        it "has many RoundSets" do
            pending "need to add create associated models and add associations"
            expect(test_score_session.round_sets).to include(assoc_round_set)
        end
    
        it "has many Shots" do
            pending "need to add create associated models and add associations"
            expect(test_score_session.shots).to include(assoc_shot)
        end
    
        it "has many ArcherCategories" do
            pending "need to add create associated models and add associations"
            expect(test_score_session.archer_categories).to include(assoc_category)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the score sessions's name with correct capitalization" do
            duplicate[:name] = "2020 world cup"
            score_session = ScoreSession.create(duplicate)
            expect(score_session.name).to eq(duplicate[:name].titlecase)
        end

        it "can assign and format the rank from any good input" do
            st_scenarios = ["1", "21", "0021", "1ND", "21ST", "0021st"]
            nd_scenarios = ["2", "22","0022", "2ST", "22ND", "0022nd"]
            rd_scenarios = ["3", "23", "0023", "3ST", "23RD", "0023rd"]
            th_scenarios = ["4", "24", "0024", "4ST", "24TH", "0024th", "11", "0011"]
            win_scenarios = ["W", "w", "Win", "win", "Won", "won"]
            lose_scenarios = ["L", "l", "Loss", "loss", "Lost", "lost"]

            st_scenarios.each do | test_value |
                duplicate[:rank] = test_value
                score_session = ScoreSession.create(duplicate)
                expect(score_session.rank).to eq("#{test_value.to_i.to_s}st")
            end

            nd_scenarios.each do | test_value |
                duplicate[:rank] = test_value
                score_session = ScoreSession.create(duplicate)
                expect(score_session.rank).to eq("#{test_value.to_i.to_s}nd")
            end

            rd_scenarios.each do | test_value |
                duplicate[:rank] = test_value
                score_session = ScoreSession.create(duplicate)
                expect(score_session.rank).to eq("#{test_value.to_i.to_s}rd")
            end

            th_scenarios.each do | test_value |
                duplicate[:rank] = test_value
                score_session = ScoreSession.create(duplicate)
                expect(score_session.rank).to eq("#{test_value.to_i.to_s}th")
            end

            win_scenarios.each do | test_value |
                duplicate[:rank] = test_value
                score_session = ScoreSession.create(duplicate)
                expect(score_session.rank).to eq("Win")
            end

            lose_scenarios.each do | test_value |
                duplicate[:rank] = test_value
                score_session = ScoreSession.create(duplicate)
                expect(score_session.rank).to eq("Loss")
            end
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_score_session).to be_invalid
        end
    end
end
