require 'rails_helper'

RSpec.describe Shot, type: :model do
    # add attrs (must be in hash) for all regular valid instances of Shot
        # one with all attrs defined and one with only required attrs defined
        # doing this separately makes writing the expect statments easier
    let(:valid_all) {
        {date: "2020-09-01", end_num: 5, shot_num: 5, score_entry: "5",  set_score: 2}
    }

    let(:multi_valid_all) {
        multi_shot_11: {date: "2020-09-01", end_num: 1, shot_num: 1, score_entry: "X",  set_score: 2}
        multi_shot_12: {date: "2020-09-01", end_num: 1, shot_num: 2, score_entry: "10", set_score: 2}
        multi_shot_13: {date: "2020-09-01", end_num: 1, shot_num: 3, score_entry: "M",  set_score: 2}
        multi_shot_21: {date: "2020-09-01", end_num: 2, shot_num: 1, score_entry: "9",  set_score: ""}
        multi_shot_22: {date: "2020-09-01", end_num: 2, shot_num: 2, score_entry: "8",  set_score: ""}
        multi_shot_23: {date: "2020-09-01", end_num: 2, shot_num: 3, score_entry: "7",  set_score: ""}
    }
    
    # create the main valid test instances, using the valid_all attrs (not persisted until called)
        # only add multiple instantiations if need multiple instances at the same time for testing
        # if just need to adjust attr values, use the attr sets below
    
    let(:test_shot) {
        Shot.create(valid_all)
    }

    let(:test_multi) {
        multi_valid_all.each do | shot, attrs |
            let(:shot) { Shot.create(attrs) }
        end
    }
    
    # add all instances of AssocModel needed for testing associations (not persisted until called)
        # should be valid with all attrs
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

    let(:assoc_score_session) {
        ScoreSession.create(
            name: "2020 World Cup", 
            score_session_type: "Tournament", 
            city: "Oxford", 
            state: "OH", 
            country: "USA", 
            start_date: "2020-09-01", 
            end_date: "2020-09-05", 
            rank: "1st", 
            active: true
        )
    }

    let(:assoc_round) {
        Round.create(name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4, user_edit: false)
    }

    let(:assoc_round_set) {
        RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
    }

    let(:assoc_category) {
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
        DistanceTargetCategory.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
    }
    
    # take valid_all and remove any non-required atts and auto-assign (not auto_format) attrs, all should be formatted correctly already
    let(:valid_req) {
        {date: "2020-09-01", end_num: 5, shot_num: 5, score_entry: "5"}
    }

    # exact duplicate of valid_all - use as whole for testing unique values
    # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.)
    let(:duplicate) {
        {date: "2020-09-01", end_num: 5, shot_num: 5, score_entry: "5",  set_score: 2}
    }

    # start w/ valid_all, change all values, make any auto-assign blank (don't delete)
    let(:update) {
        {date: "2020-09-05", end_num: 6, shot_num: 6, score_entry: "6",  set_score: ""}
    }

    # every attr blank
    let(:blank) {
        {date: "", end_num: "", shot_num: "", score_entry: "",  set_score: ""}
    }
  
    # add the following default error messages for different validation failures (delete any unnecessary for model)
    let(:default_missing_message) {"can't be blank"}
    let(:default_duplicate_message) {"has already been taken"}
    let(:default_inclusion_message) {"is not included in the list"}
    let(:default_number_message) {"is not a number"}
    let(:default_format_message) {"is invalid"}
    
    let(:missing_score_entry_message) {"You must provide a set score for shot #{shot.shot_num}."}
    let(:missing_set_score_message) {"You must enter a set score for the end."}
    # let(:inclusion_date_message) {"Date must be between #{assoc_score_session.start_date} and #{assoc_score_session.end_date}."}

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances" do
        describe "valid with all required and unrequired input data" do
            it "instance is valid with all attributes" do
                expect(Shot.all.count).to eq(0)

                expect(test_shot).to be_valid
                expect(Shot.all.count).to eq(1)
                expect(test_shot.date).to eq(valid_all[:date])
                expect(test_shot.end_num).to eq(valid_all[:end_num])
                expect(test_shot.shot_num).to eq(valid_all[:shot_num])
                expect(test_shot.score_entry).to eq(valid_all[:score_entry])
                expect(test_shot.set_score).to eq(valid_all[:set_score])
            end
            
            it "instance is valid with only required attributes" do
                expect(Shot.all.count).to eq(0)
                shot = Shot.create(valid_req)

                expect(shot).to be_valid
                expect(Shot.all.count).to eq(1)
                expect(shot.date).to eq(valid_req[:date])
                expect(shot.end_num).to eq(valid_req[:end_num])
                expect(shot.shot_num).to eq(valid_req[:shot_num])
                expect(shot.score_entry).to eq(valid_req[:score_entry])
                expect(shot.set_score).to eq(valid_req[:set_score])
            end

            it "instance creates any auto-generated data for attrs" do
                pending "see if use this for auto creation of set_score"
            end

            it "instance is valid when updating all attrs" do
                test_shot.update(update)
                
                expect(test_shot).to be_valid
                expect(test_shot.date).to eq(update[:date])
                expect(test_shot.end_num).to eq(update[:end_num])
                expect(test_shot.shot_num).to eq(update[:shot_num])
                expect(test_shot.score_entry).to eq(update[:score_entry])
                expect(test_shot.set_score).to eq(update[:set_score])
            end
        end

        describe "invalid and has correct error message if" do
            it "missing required attributes" do
                shot = Shot.create(blank)

                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(0)
                expect(shot.errors.messages[:date]).to include(default_missing_message)
                expect(shot.errors.messages[:end_num]).to include(default_missing_message)
                expect(shot.errors.messages[:shot_num]).to include(default_missing_message)
                expect(shot.errors.messages[:score_entry]).to include(missing_score_entry_message)
                expect(test_shot.set_score).to eq(blank[:set_score])

                # expect(shot.errors.messages[:date]).to include(inclusion_date_message)
            end

            it "missing set_score during a RoundSet with 'Set' score method" do
                assoc_round_set.update(score_method: "Set")
                shot = Shot.create(blank)

                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(0)
                expect(shot.errors.messages[:set_score]).to include(missing_set_score_message)
            end

            it "date is outside allowable inputs" do
                bad_scenarios = ["2020-08-31", "2020-09-06"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:end_num] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:date]).to include(default_inclusion_message)

                    # expect(shot.errors.messages[:date]).to include(inclusion_date_message)
                end
            end
            
            it "end_num is outside allowable inputs" do
                bad_scenarios = ["0", "-1", "7", "bad"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:end_num] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:end_num]).to include(default_inclusion_message)
                end
            end

            it "shot_num is outside allowable inputs" do
                bad_scenarios = ["0", "-1", "7", "bad"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:shot_num] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:shot_num]).to include(default_inclusion_message)
                end
            end

            it "score_entry is outside allowable inputs" do
                bad_scenarios = ["0", "-1", "11", "bad", "MX", "b"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:score_entry] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:score_entry]).to include(default_inclusion_message)
                end
            end

            it "set_score is outside allowable inputs" do
                bad_scenarios = ["-1", "3", "bad"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:set_score] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:set_score]).to include(default_inclusion_message)
                end
            end

            it "the score_entry value is X when there is no x-ring" do
                assoc_target
                duplicate[:score_entry] = "X"
                shot = Shot.create(duplicate)
                
                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(0)
                expect(shot.errors.messages[:score_entry]).to include(default_inclusion_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load all AssocModels that must be in DB for tests to work
        end

        it "belongs to Archer" do
            pending "need to add associations"
            expect(test_shot.archer).to eq(assoc_archer)
        end

        it "belongs to ScoreSession" do
            pending "need to add associations"
            expect(test_shot.score_session).to eq(assoc_score_session)
        end
      
        it "belongs to Round" do
            pending "need to add associations"
            expect(test_shot.round).to eq(assoc_round)
        end
    
        it "belongs to RoundSet" do
            pending "need to add associations"
            expect(test_shot.round_set).to eq(assoc_round_set)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            assoc_score_session
            assoc_round
            assoc_round_set
            assoc_target
            test_multi
        end

        it "can auto-assign the set_score for all shots from same end at same time if entered at last shot" do
            multi_valid_all[:multi_shot_23][:set_score] = 1

            expect(multi_shot_11.set_score).to eq(multi_valid_all[:multi_shot_11][:set_score])
            expect(multi_shot_21.set_score).to eq(1)
            expect(multi_shot_22.set_score).to eq(1)
            expect(multi_shot_21.set_score).to eq(1)
        end

        it "set_score won't update for any shot if it doesn't come from the last shot of the end" do
            multi_valid_all[:multi_shot_21][:set_score] = 1

            expect(multi_shot_11.set_score).to eq(multi_valid_all[:multi_shot_11][:set_score])
            expect(multi_shot_21.set_score).to eq(multi_valid_all[:multi_shot_21][:set_score])
            expect(multi_shot_22.set_score).to eq(multi_valid_all[:multi_shot_22][:set_score])
            expect(multi_shot_23.set_score).to eq(multi_valid_all[:multi_shot_23][:set_score])
        end

        it "can calculate a point value (as score) from the score entry" do
            expect(multi_shot_11.score).to eq(target.max_score)
            expect(multi_shot_12.score).to eq(multi_valid_all[:multi_shot_12][:score_entry].to_i)
            expect(multi_shot_13.score).to eq(0)
        end

        it "can find a specific end" do
            want to be able to to call shot.rs_end
        end

        # it "can find all shots that belong to same end" do
            # want to be able to to call shot.end_shots
        # end

        it "can calculate the total score for an end" do
            test_end_one_score = multi_shot_11.score + multi_shot_12.score + multi_shot_13.score
            test_end_two_score = multi_valid_all[:multi_shot_21][:score_entry].to_i + multi_valid_all[:multi_shot_22][:score_entry].to_i + multi_valid_all[:multi_shot_23][:score_entry].to_i

            expect(multi_shot_11.end_score).to eq(test_end_one_score)
            expect(multi_shot_12.end_score).to eq(test_end_one_score)
            expect(multi_shot_11.end_score).to eq(test_end_one_score)

            expect(multi_shot_21.end_score).to eq(test_end_two_score)
            expect(multi_shot_22.end_score).to eq(test_end_two_score)
            expect(multi_shot_21.end_score).to eq(test_end_two_score)
        end        

        # #####################################################
        # should I build an end model?????
        
        # it "can find all shots that belong to same end" do
        #     expect(multi_shot_11.set_score).to eq(multi_valid_all[:multi_shot_11][:set_score])
        # end

        # it "can track if end it is in is complete or not" do
            # can use this to identify the active end so only display form for that end
            # want to be able to to call shot.end_complete?
        # end
        # #####################################################


        # #####################################################
        # reference

        multi_valid_all[:multi_shot_21][:set_score] = 1
            expect(multi_shot_11.set_score).to eq(multi_valid_all[:multi_shot_11][:set_score])
            expect(multi_shot_21.set_score).to eq(multi_valid_all[:multi_shot_21][:set_score])
            expect(multi_shot_22.set_score).to eq(multi_valid_all[:multi_shot_21][:set_score])
            expect(multi_shot_23.set_score).to eq(multi_valid_all[:multi_shot_21][:set_score])
            
            multi_valid_all[:multi_shot_21][:set_score]
            multi_valid_all[:multi_shot_22][:set_score]
            multi_valid_all[:multi_shot_23][:set_score]

            multi_valid_all = 
            multi_shot_11: {end_num: 1, shot_num: 1, score_entry: "X",  set_score: 2}
            multi_shot_12: {end_num: 1, shot_num: 2, score_entry: "10", set_score: 2}
            multi_shot_13: {end_num: 1, shot_num: 3, score_entry: "M",  set_score: 2}
            multi_shot_21: {end_num: 2, shot_num: 1, score_entry: "9",  set_score: ""}
            multi_shot_22: {end_num: 2, shot_num: 2, score_entry: "9",  set_score: ""}
            multi_shot_23: {end_num: 2, shot_num: 3, score_entry: "9",  set_score: ""}
        # #####################################################

        
        it "can identify its distance" do
            pending "need to add associations"
            expect(test_shot.distance).to eq(assoc_dist_targ.distance)
        end

        it "can identify its target" do
            pending "need to add associations"
            expect(test_shot.target).to eq(assoc_dist_targ.target)
        end

        # it "can identify its archer's archer_category for the round it's in" do
        #     pending "need to add associations"
        #     want to be able to to call shot.archer_category
        # end


        
        
        

        it "helpers TBD" do
            pending "add as needed"
            expect(test_shot).to be_invalid
        end
    end
end
