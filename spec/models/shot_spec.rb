require 'rails_helper'

RSpec.describe Shot, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {number: 2, score_entry: "5"}
    }

    let(:test_shot) {
        Shot.create(test_all)
    }
    
    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing
    # this is how 2 ends of three would look, covers all score_entry options
    let(:multi_test_all) {
        {
            multi_shot_11: {number: 1, score_entry: "X"}, 
            multi_shot_12: {number: 2, score_entry: "10"}, 
            multi_shot_13: {number: 3, score_entry: "M"}, 
            multi_shot_21: {number: 1, score_entry: "9"}, 
            multi_shot_22: {number: 2, score_entry: "8"}, 
            multi_shot_23: {number: 3, score_entry: "7"}
        }
    }

    let(:test_multi) {
        multi_test_all.each do | shot, attrs |
            let(:shot) { Shot.create(attrs) }
        end
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {score_entry: "5"}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {number: 2, score_entry: "5"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {number: "", score_entry: "4"}
    }

    # every attr blank
    let(:blank) {
        {number: "", score_entry: ""}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_num) {2}
    # let(:default_attr) {}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_score_entry_message) {"You must enter a score for shot #{shot.number}."}

    let(:inclusion_score_entry_message) {"Enter only X, M or a number between #{shot.target.score_areas} and #{shot.target.max_score}."}
    let(:inclusion_score_entry_message_no_x) {"Enter only M or a number between #{shot.target.score_areas} and #{shot.target.max_score}."}
    
    # let(:missing_attr_message) {}
    # let(:duplicate_attr_message) {}
    # let(:inclusion_attr_message) {}
    # let(:number_attr_message) {}
    # let(:format_attr_message) {}

    # ###################################################################
    # define tests
    # ###################################################################
    

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Shot.all.count).to eq(0)

                expect(test_shot).to be_valid
                expect(Shot.all.count).to eq(1)
                
                expect(test_shot.number).to eq(test_all[:number])
                expect(test_shot.score_entry).to eq(test_all[:score_entry])
            end
            
            it "given only required attributes" do
                expect(Shot.all.count).to eq(0)
                shot = Shot.create(test_req)

                expect(shot).to be_valid
                expect(Shot.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(shot.score_entry).to eq(test_req[:score_entry])
                
                # not req input tests (number auto-asigned from missing)
                expect(shot.number).to eq(assigned_num)
            end

            it "given no attributes at instantiation" do
                expect(Shot.all.count).to eq(0)
                shot = Shot.create(blank)

                expect(shot).to be_valid
                expect(Shot.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(shot.score_entry).to be_blank

                # not req input tests (number auto-asigned from missing)
                expect(shot.number).to eq(assigned_num)
            end

            it "updating all attributes" do
                test_shot.update(update)

                expect(test_shot).to be_valid

                # req input tests (should have value in update)
                expect(test_shot.score_entry).to eq(update[:score_entry])
                
                # not req input tests (number auto-asigned from blank)
                expect(test_shot.number).to eq(assigned_num)
            end
        end

        describe "invalid and has correct error message when" do
            it "missing score_entry upon update" do
                shot = Shot.create(blank)
                expect(shot).to be_valid
                expect(Shot.all.count).to eq(1)

                shot.update(blank)

                expect(shot).to be_invalid
                expect(shot.errors.messages[:score_entry]).to include(missing_score_entry_message)
                expect(shot.number).to eq(assigned_num)
            end

            it "number is outside allowable inputs" do
                valid_score_session
                over_max = valid_rset.ends.first.shots.count + 1
                bad_scenarios = [0, -1, over_max, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:number] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:number]).to include(default_number_message)
                end
            end

            it "score_entry is outside allowable inputs" do
                # shot instance must have same target as test_shot
                under_min = test_shot.target.score_areas - 1
                over_max = test_shot.target.max_score + 1
                bad_scenarios = ["0", "-1", under_min, over_max, "bad", "MX"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:score_entry] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:score_entry]).to include(inclusion_score_entry_message)
                end
            end

            it "the score_entry value is X when there is no x-ring" do
                valid_target.x_ring = false
                valid_target.save
                
                duplicate[:score_entry] = "X"
                shot = Shot.create(duplicate)
                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(0)
                expect(shot.errors.messages[:score_entry]).to include(inclusion_score_entry_message_no_x)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # before_archer
            before_shot
        end

        describe "belongs to Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_test_shot.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                update[:archer_id] = ""
                check_test_shot = assoc_archer.test_shots.create(update)
                
                expect(check_test_shot.archer).to eq(assoc_archer)
                expect(check_test_shot.archer.name).to include(assoc_archer.name)
            end
        end

        describe "belongs to ScoreSession and" do
            it "can find an associated object" do
                assoc_score_session = valid_score_session
                expect(test_test_shot.score_session).to eq(assoc_score_session)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_score_session = valid_score_session
                update[:score_session_id] = ""
                check_test_shot = assoc_score_session.test_shots.create(update)
                
                expect(check_test_shot.score_session).to eq(assoc_score_session)
                expect(check_test_shot.score_session.name).to include(assoc_score_session.name)
            end
        end

        describe "belongs to Round and" do
            it "can find an associated object" do
                assoc_round = valid_round
                expect(test_test_shot.round).to eq(assoc_round)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_round = valid_round
                update[:round_id] = ""
                check_test_shot = assoc_round.test_shots.create(update)
                
                expect(check_test_shot.round).to eq(assoc_round)
                expect(check_test_shot.round.name).to include(assoc_round.name)
            end
        end

        describe "belongs to Rset and" do
            it "can find an associated object" do
                assoc_rset = valid_rset
                expect(test_test_shot.rset).to eq(assoc_rset)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_rset = valid_rset
                update[:rset_id] = ""
                check_test_shot = assoc_rset.test_shots.create(update)
                
                expect(check_test_shot.rset).to eq(assoc_rset)
                expect(check_test_shot.rset.name).to include(assoc_rset.name)
            end
        end

        describe "belongs to End and" do
            it "can find an associated object" do
                assoc_end = valid_end
                expect(test_test_shot.end).to eq(assoc_end)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_end = valid_end
                update[:end_id] = ""
                check_test_shot = assoc_end.test_shots.create(update)
                
                expect(check_test_shot.end).to eq(assoc_end)
                expect(check_test_shot.end.name).to include(assoc_end.name)
            end
        end





        # it "belongs to Archer" do
        #     expect(test_shot.archer).to eq(valid_archer)
        # end

        # it "belongs to ScoreSession" do
        #     expect(test_shot.score_session).to eq(valid_score_session)
        # end
      
        # it "belongs to Round" do
        #     expect(test_shot.round).to eq(valid_round)
        # end
    
        # it "belongs to Rset" do
        #     expect(test_shot.rset).to eq(valid_set)
        # end

        # it "belongs to End" do
        #     expect(test_shot.end).to eq(valid_end)
        # end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        # before(:each) do
        #     valid_score_session
        #     valid_round
        #     valid_set
        #     valid_target
        #     test_multi
        # end

        # it "can auto-assign the set_score for all shots from same end at same time if entered at last shot" do
        #     multi_test_all[:multi_shot_23][:set_score] = 1

        #     expect(multi_shot_11.set_score).to eq(multi_test_all[:multi_shot_11][:set_score])
        #     expect(multi_shot_21.set_score).to eq(1)
        #     expect(multi_shot_22.set_score).to eq(1)
        #     expect(multi_shot_21.set_score).to eq(1)
        # end

        # it "set_score won't update for any shot if it doesn't come from the last shot of the end" do
        #     multi_test_all[:multi_shot_21][:set_score] = 1

        #     expect(multi_shot_11.set_score).to eq(multi_test_all[:multi_shot_11][:set_score])
        #     expect(multi_shot_21.set_score).to eq(multi_test_all[:multi_shot_21][:set_score])
        #     expect(multi_shot_22.set_score).to eq(multi_test_all[:multi_shot_22][:set_score])
        #     expect(multi_shot_23.set_score).to eq(multi_test_all[:multi_shot_23][:set_score])
        # end

        # it "can calculate a point value (as score) from the score entry" do
        #     expect(multi_shot_11.score).to eq(target.max_score)
        #     expect(multi_shot_12.score).to eq(multi_test_all[:multi_shot_12][:score_entry].to_i)
        #     expect(multi_shot_13.score).to eq(0)
        # end

        # it "can find a specific end" do
        #     want to be able to to call shot.rs_end
        # end

        # # it "can find all shots that belong to same end" do
        #     # want to be able to to call shot.end_shots
        # # end

        # it "can calculate the total score for an end" do
        #     test_end_one_score = multi_shot_11.score + multi_shot_12.score + multi_shot_13.score
        #     test_end_two_score = multi_test_all[:multi_shot_21][:score_entry].to_i + multi_test_all[:multi_shot_22][:score_entry].to_i + multi_test_all[:multi_shot_23][:score_entry].to_i

        #     expect(multi_shot_11.end_score).to eq(test_end_one_score)
        #     expect(multi_shot_12.end_score).to eq(test_end_one_score)
        #     expect(multi_shot_11.end_score).to eq(test_end_one_score)

        #     expect(multi_shot_21.end_score).to eq(test_end_two_score)
        #     expect(multi_shot_22.end_score).to eq(test_end_two_score)
        #     expect(multi_shot_21.end_score).to eq(test_end_two_score)
        # end        

        # # #####################################################
        # # should I build an end model?????
        
        # # it "can find all shots that belong to same end" do
        # #     expect(multi_shot_11.set_score).to eq(multi_test_all[:multi_shot_11][:set_score])
        # # end

        # # it "can track if end it is in is complete or not" do
        #     # can use this to identify the active end so only display form for that end
        #     # want to be able to to call shot.end_complete?
        # # end
        # # #####################################################


        # # #####################################################
        # # reference

        # multi_test_all[:multi_shot_21][:set_score] = 1
        #     expect(multi_shot_11.set_score).to eq(multi_test_all[:multi_shot_11][:set_score])
        #     expect(multi_shot_21.set_score).to eq(multi_test_all[:multi_shot_21][:set_score])
        #     expect(multi_shot_22.set_score).to eq(multi_test_all[:multi_shot_21][:set_score])
        #     expect(multi_shot_23.set_score).to eq(multi_test_all[:multi_shot_21][:set_score])
            
        #     multi_test_all[:multi_shot_21][:set_score]
        #     multi_test_all[:multi_shot_22][:set_score]
        #     multi_test_all[:multi_shot_23][:set_score]

        #     multi_test_all = 
        #     multi_shot_11: {end_num: 1, number: 1, score_entry: "X",  set_score: 2}
        #     multi_shot_12: {end_num: 1, number: 2, score_entry: "10", set_score: 2}
        #     multi_shot_13: {end_num: 1, number: 3, score_entry: "M",  set_score: 2}
        #     multi_shot_21: {end_num: 2, number: 1, score_entry: "9",  set_score: ""}
        #     multi_shot_22: {end_num: 2, number: 2, score_entry: "9",  set_score: ""}
        #     multi_shot_23: {end_num: 2, number: 3, score_entry: "9",  set_score: ""}
        # # #####################################################

        
        # it "can identify its distance" do
        #     pending "need to add associations"
        #     expect(test_shot.distance).to eq(valid_dist_targ.distance)
        # end

        # it "can identify its target" do
        #     pending "need to add associations"
        #     expect(test_shot.target).to eq(valid_dist_targ.target)
        # end

        # # it "can identify its archer's archer_category for the round it's in" do
        # #     pending "need to add associations"
        # #     want to be able to to call shot.archer_category
        # # end


        
        
        

        it "helpers TBD" do
            pending "add as needed"
            expect(test_shot).to be_invalid
        end
    end
end
