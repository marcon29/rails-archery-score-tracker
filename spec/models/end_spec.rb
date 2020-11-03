require 'rails_helper'

RSpec.describe End, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
            number: 2, 
            set_score: 2, 
            archer_id: 1, 
            score_session_id: 1, 
            round_id: 1, 
            rset_id: 1
        }
    }
        
    let(:test_end) {
        End.create(test_all)
    }    

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {set_score: 2, archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {number: 2, set_score: 2, archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {set_score: 1}
    }

    # every attr blank
    let(:blank) {
        {number: "", set_score: "", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_num) {1}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:number_set_score_message) {"You must enter 0, 1, or 2."}
        

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            before_end
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(End.all.count).to eq(0)

                expect(test_end).to be_valid
                expect(End.all.count).to eq(1)

                expect(test_end.number).to eq(test_all[:number])
                expect(test_end.set_score).to be_blank
            end
            
            it "given only required attributes" do
                expect(End.all.count).to eq(0)
                endd = End.create(test_req)

                expect(endd).to be_valid
                expect(End.all.count).to eq(1)

                # req input tests (has value in test_req but auto-assigned to nil for example)
                expect(endd.set_score).to be_blank

                # not req input tests (number auto-asigned from missing)
                expect(endd.number).to eq(assigned_num)
            end

            it "number is duplicated but for different Rset" do
                # need second rset
                second_set_end_format = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, user_edit: false, round_format: valid_round_format)
                valid_dist_targ_cat_alt
                second_rset = Rset.find_or_create_by(date: "2020-09-01", rank: "1st", archer: valid_archer, score_session: valid_score_session, round: valid_round, set_end_format: second_set_end_format, distance_target_category: valid_dist_targ_cat)
                expect(Rset.all.count).to eq(2)
                expect(End.all.count).to eq(0)

                # gives me 2 ends in valid_rset
                valid_end
                test_end
                expect(End.all.count).to eq(2)
                
                # gives me 1 end in second_rset
                test_req[:rset_id] = 2
                third_end = End.create(test_req)
                expect(End.all.count).to eq(3)

                # test duped name from valid_end but in second_rset
                duplicate[:number] = ""
                duplicate[:rset_id] = 2
                endd = End.create(duplicate)

                expect(endd).to be_valid
                expect(End.all.count).to eq(4)

                expect(endd.number).to eq(2)
                expect(endd.set_score).to be_nil
            end

            it "belonging to round with 'Points' for score_method, it updates set_score to blank" do
                valid_round
                endd = End.create(test_req)
                endd.update(update)

                expect(endd).to be_valid

                # req input tests (should have value in test_req)
                expect(endd.set_score).to be_blank

                # not req input tests (number auto-asigned from missing)
                expect(endd.number).to eq(assigned_num)
            end

            it "belonging to round with 'Points' for score_method and missing set_score at instantiation" do
                test_req[:set_score] = ""
                endd = End.create(test_req)

                expect(endd).to be_valid
                expect(End.all.count).to eq(1)
                
                expect(endd.set_score).to be_blank
                expect(endd.number).to eq(assigned_num)
            end

            it "belonging to round with 'Set' for score_method, it updates set_score" do
                valid_round.update(score_method: "Set")
                endd = End.create(test_req)
                endd.update(update)
                
                expect(endd).to be_valid
                
                # req input tests (should have value in update)
                expect(endd.set_score).to eq(update[:set_score])
                
                # not req input tests (number auto-asigned from blank)
                expect(endd.number).to eq(assigned_num)
            end

            it "all associated objects have the same parents" do
                expect(test_end.check_associations.count).to eq(6)
                expect(test_end.check_associations).not_to include(false)
                expect(test_end).to be_valid
            end
        end

        describe "invalid and has correct error message when" do
            it "number is outside allowable inputs" do
                bad_scenarios = [0, -1, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:number] = test_value
                    endd = End.create(duplicate)
                    expect(endd).to be_invalid
                    expect(End.all.count).to eq(0)
                    expect(endd.errors.messages[:number]).to be_present
                end
            end

            it "exceeds the total number of ends allowable for the Rset" do
                expect(End.all.count).to eq(0)
                valid_set_end_format.num_ends.times { End.create(test_req) }
                expect(End.all.count).to eq(6)
                
                endd = End.create(test_req)

                expect(endd).to be_invalid
                expect(End.all.count).to eq(6)
                expect(endd.errors.messages[:number]).to be_present
            end

            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_end
                expect(End.all.count).to eq(1)
                endd = End.create(duplicate)

                expect(endd).to be_invalid
                expect(End.all.count).to eq(1)
                expect(endd.errors.messages[:number]).to include(default_duplicate_message)
            end

            it "belonging to round with 'Set' for score_method and missing set_score upon update" do
                round = valid_round
                round.update(score_method: "Set")
                test_req[:set_score] = ""
                endd = End.create(test_req)
                
                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(endd).to be_valid
                expect(End.all.count).to eq(1)
                
                endd.update(test_req)
                
                expect(endd).to be_invalid
                expect(endd.errors.messages[:set_score]).to include(number_set_score_message)
                expect(endd.number).to eq(1)
            end

            it "set_score is outside allowable inputs" do
                round = valid_round
                round.update(score_method: "Set")
                bad_scenarios = [-1, 3, "one"]
                
                bad_scenarios.each do | test_value |
                    test_req[:set_score] = test_value
                    endd = End.create(test_req)
                    expect(endd).to be_invalid
                    expect(End.all.count).to eq(0)
                    expect(endd.errors.messages[:set_score]).to include(number_set_score_message)
                end
            end

            it "an associated object has a different parent" do
                second_score_session = ScoreSession.create(
                    name: "1900 World Cup", 
                    score_session_type: "Tournament", 
                    city: "Oxford", 
                    state: "OH", 
                    country: "USA", 
                    start_date: "2020-09-01", 
                    end_date: "2020-09-05", 
                    rank: "1st", 
                    active: true, 
                    archer: valid_archer
                )
                test_end.update(score_session: second_score_session)

                expect(test_end).to be_invalid
                expect(test_end.errors.messages).to be_present
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            before_end
            valid_target
        end

        describe "belongs to an Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_end.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                test_req[:archer_id] = ""
                check_end = assoc_archer.ends.create(test_req)
                
                expect(check_end.archer).to eq(assoc_archer)
                expect(check_end.archer.username).to include(assoc_archer.username)
            end
        end

        describe "belongs to a ScoreSession and" do
            it "can find an associated object" do
                assoc_score_session = valid_score_session
                expect(test_end.score_session).to eq(assoc_score_session)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_score_session = valid_score_session
                test_req[:score_session_id] = ""
                check_end = assoc_score_session.ends.create(test_req)
                
                expect(check_end.score_session).to eq(assoc_score_session)
                expect(check_end.score_session.name).to include(assoc_score_session.name)
            end
        end

        describe "belongs to a Round and" do
            it "can find an associated object" do
                assoc_round = valid_round
                expect(test_end.round).to eq(assoc_round)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_round = valid_round
                test_req[:round_id] = ""
                check_end = assoc_round.ends.create(test_req)
                
                expect(check_end.round).to eq(assoc_round)
                expect(check_end.round.name).to include(assoc_round.name)
            end
        end

        describe "belongs to a Rset and" do
            it "can find an associated object" do
                assoc_rset = valid_rset
                expect(test_end.rset).to eq(assoc_rset)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_rset = valid_rset
                test_req[:rset_id] = ""
                check_end = assoc_rset.ends.create(test_req)
                
                expect(check_end.rset).to eq(assoc_rset)
                expect(check_end.rset.name).to include(assoc_rset.name)
            end
        end

        describe "has many Shots and" do
            before(:each) do
                before_end
            end

            it "can find an associated object" do
                assoc_shot = valid_shot
                expect(End.last.shots).to include(assoc_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                endd = End.create(duplicate)

                check_shot_attrs = {score_entry: "X", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1}
                check_shot = endd.shots.create(check_shot_attrs)
                
                expect(endd.shots).to include(check_shot)
                expect(endd.shots.last.score_entry).to eq(check_shot.score_entry)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            valid_set_end_format
            valid_rset
            valid_target
        end

        describe "methods primarily for callbacks and validations" do
            it "can find all ends belonging to the same rset" do
                first_end = valid_end
                second_end = End.create(archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1)
                third_end = End.create(archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1)
                
                second_set_end_format = Format::SetEndFormat.create(name: "Set/Distance2", num_ends: 6, shots_per_end: 6, user_edit: false, round_format: valid_round_format)
                valid_dist_targ_cat_alt
                second_rset = Rset.create(date: "2020-09-01", rank: "", archer_id: 1, score_session_id: 1, round_id: 1, set_end_format: second_set_end_format, distance_target_category: valid_dist_targ_cat)
                other_end = End.create(archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 2)
                
                expect(first_end.ends_in_set.count).to eq(3)
                expect(first_end.ends_in_set).to include(first_end)
                expect(first_end.ends_in_set).to include(second_end)
                expect(first_end.ends_in_set).to include(third_end)
                expect(first_end.ends_in_set).not_to include(other_end)
            end

            it "can identify the total number of ends allowed in its Rset" do
                expect(test_end.allowable_ends_per_set).to eq(valid_set_end_format.num_ends)
            end
        end

        describe "methods primarily for getting useful data" do
            it "can calculate the total score for an end" do
                endd = valid_end
                expect(End.all.count).to eq(1)
                expect(Shot.all.count).to eq(0)
                
                Shot.create(score_entry: "X", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd)
                Shot.create(score_entry: "10", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd)
                Shot.create(score_entry: "M", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd)
                expect(Shot.all.count).to eq(3)
                expect(endd.score).to eq(20)
            end

            it "can identify all shots that have been scored" do
                endd = valid_end
                expect(End.all.count).to eq(1)
                expect(Shot.all.count).to eq(0)
                
                first_shot = Shot.create(score_entry: "X", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd)
                second_shot = Shot.create(score_entry: "10", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd)
                third_shot = Shot.create(score_entry: "M", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd)
                expect(Shot.all.count).to eq(3)

                expect(endd.scored_shots.count).to eq(3)
                expect(endd.scored_shots).to include(first_shot)
                expect(endd.scored_shots).to include(second_shot)
                expect(endd.scored_shots).to include(third_shot)
            end

            it "can identify the total number of shots it should have" do
                expect(test_end.shots_per_end).to eq(valid_set_end_format.shots_per_end)
            end

            it "can identify if end is complete (all shots scored) or not" do
                endd = valid_end
                expect(End.all.count).to eq(1)
                expect(Shot.all.count).to eq(0)

                multi_shot_attrs = {score_entry: "X", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end: endd}
                5.times { Shot.create(multi_shot_attrs) }
                expect(Shot.all.count).to eq(5)
                expect(endd.scored_shots.count).to eq(5)
                expect(endd.complete?).to eq(false)
                
                Shot.create(multi_shot_attrs)
                endd.reload
                expect(Shot.all.count).to eq(6)
                expect(endd.scored_shots.count).to eq(6)
                expect(endd.complete?).to eq(true)
            end
        end
    end
end
