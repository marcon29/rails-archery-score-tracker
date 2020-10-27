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
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing

    # let(:test_end_set) {
    #     End.create(number: 1, score_method: "Set",  set_score: 2)
    # }


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
        {number: "", set_score: 1, archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1}
    }

    # every attr blank
    let(:blank) {
        {number: "", set_score: "", archer_id: "", score_session_id: "", round_id: "", rset_id: ""}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_num) {2}
    # let(:default_attr) {}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    # let(:missing_set_score_message) {"You must enter a set score for the end."}
    let(:number_set_score_message) {"You must enter 0, 1, or 2."}
    
    # let(:duplicate_attr_message) {}
    # let(:inclusion_attr_message) {}
    # let(:number_attr_message) {}
    # let(:format_attr_message) {}
    

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            # this needs to always run before creating an archer so validations work (creates inclusion lists)
            before_archer
            valid_archer
            valid_score_session
            valid_round
            valid_rset
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(End.all.count).to eq(0)

                expect(test_end).to be_valid
                expect(End.all.count).to eq(1)

                expect(test_end.number).to eq(test_all[:number])
                expect(test_end.set_score).to eq(test_all[:set_score])
            end
            
            it "given only required attributes" do
                expect(End.all.count).to eq(0)
                endd = End.create(test_req)

                expect(endd).to be_valid
                expect(End.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(test_end.set_score).to eq(test_req[:set_score])

                # not req input tests (number auto-asigned from missing)
                expect(test_end.number).to eq(assigned_num)
            end

            it "belonging to round with 'Points' for score_method and given no attributes at instantiation" do
                valid_round

                expect(End.all.count).to eq(0)
                endd = End.create(blank)

                expect(endd).to be_valid
                expect(End.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(endd.set_score).to be_blank

                # not req input tests (number auto-asigned from missing)
                expect(endd.number).to eq(assigned_num)
            end

            it "belonging to round with 'Set' for score_method, it updates set_score" do
                valid_round.score_method = "Set"
                valid_round.save

                test_end.update(update)
                
                expect(test_end).to be_valid
                
                # req input tests (should have value in update)
                expect(test_end.set_score).to eq(update[:set_score])
                
                # not req input tests (number auto-asigned from blank)
                expect(test_end.number).to eq(assigned_num)
            end

            it "belonging to round with 'Points' for score_method, it updates set_score to blank" do
                valid_round

                test_end.update(test_req)
                
                expect(test_end).to be_valid

                # req input tests (should have value in test_req)
                expect(test_end.set_score).to be_blank

                # not req input tests (number auto-asigned from missing)
                expect(test_end.number).to eq(assigned_num)
            end
        end

        describe "invalid and has correct error message when" do
            # before(:each) do
            #     # this needs to always run before creating an archer so validations work (creates inclusion lists)
            #     before_archer
            #     valid_archer
            #     valid_score_session
            #     valid_round
            #     valid_rset
            # end

            it "belonging to round with 'Set' for score_method and missing set_score upon update" do
                valid_round.score_method = "Set"
                valid_round.save

                endd = End.create(blank)
                expect(endd).to be_valid
                expect(End.all.count).to eq(1)

                endd.update(blank)
                
                expect(endd).to be_invalid
                expect(endd.errors.messages[:set_score]).to include(number_set_score_message)
                expect(test_end.number).to eq(assigned_num)
            end

            it "number is outside allowable inputs" do
                valid_score_session
                over_max = valid_rset.ends.count + 1
                bad_scenarios = [0, -1, over_max, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:number] = test_value
                    endd = End.create(duplicate)
                    expect(endd).to be_invalid
                    expect(End.all.count).to eq(0)
                    expect(endd.errors.messages[:number]).to include(default_number_message)
                end
            end

            it "set_score is outside allowable inputs" do
                bad_scenarios = [-1, 3, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:set_score] = test_value
                    endd = End.create(duplicate)
                    expect(endd).to be_invalid
                    expect(End.all.count).to eq(0)
                    expect(endd.errors.messages[:set_score]).to include(number_set_score_message)
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        describe "belongs to an Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_end.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                update[:archer_id] = ""
                check_end = assoc_archer.ends.create(update)
                
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
                update[:score_session_id] = ""
                check_end = assoc_score_session.ends.create(update)
                
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
                update[:round_id] = ""
                check_end = assoc_round.ends.create(update)
                
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
                update[:rset_id] = ""
                check_end = assoc_rset.ends.create(update)
                
                expect(check_end.rset).to eq(assoc_rset)
                expect(check_end.rset.name).to include(assoc_rset.name)
            end
        end

        describe "has many Shots and" do
            before(:each) do
                valid_archer
                valid_score_session
                valid_round
                valid_rset
            end

            it "can find an associated object" do
                assoc_shot = valid_shot
                expect(End.last.shots).to include(assoc_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                endd = End.create(duplicate)

                check_shot_attrs = {
                    number: 1, 
                    score_entry: "X"
                }
                check_shot = endd.shots.create(check_shot_attrs)
                
                expect(endd.shots).to include(check_shot)
                expect(endd.shots.last.score_entry).to eq(check_shot.score_entry)
            end
            
            it "can re-assign instance via the associated object" do
                endd = End.create(duplicate)
                assoc_shot = valid_shot
                expect(End.last.shots).to include(assoc_shot)

                assoc_shot.end = endd
                assoc_shot.save

                expect(End.last.shots).not_to include(assoc_shot)
                expect(endd.shots).to include(assoc_shot)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_end).to be_invalid
        end
    end
end
