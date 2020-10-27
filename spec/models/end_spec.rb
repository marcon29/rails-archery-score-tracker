require 'rails_helper'

RSpec.describe End, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {number: 2, set_score: 2}
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
        {set_score: 2}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {number: 2, set_score: 2}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {number: "", set_score: 1}
    }

    # every attr blank
    let(:blank) {
        {number: "", set_score: ""}
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
        before(:each) do
            @end = End.create(duplicate)
            
            # this needs to always run before creating an archer so validations work (creates inclusion lists)
            before_archer

            @shot = Shot.create(
                archer: valid_archer, 
                score_session: valid_score_session, 
                round: valid_round, 
                rset: valid_rset, 
                end: @end, 
                number: 5, 
                score_entry: "1"
            )
        end

        it "has one Archer" do
            expect(@end.archers).to include(valid_archer)
            expect(valid_archer.ends).to include(@end)
        end

        it "has one ScoreSesson" do
            expect(@end.score_sessions).to include(valid_score_session)
            expect(valid_score_session.ends).to include(@end)
        end

        it "has one Round" do
            expect(@end.rounds).to include(valid_round)
            expect(valid_round.ends).to include(@end)
        end

        it "has on Rset" do
            expect(@end.rsets).to include(valid_rset)
            expect(valid_rset.ends).to include(@end)
        end
    
        it "has many Shots" do
            expect(@end.shots).to include(@shot)
            expect(@shot.end).to eq(@end)
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
