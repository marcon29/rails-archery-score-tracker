require 'rails_helper'

RSpec.describe Round, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "100th US Nationals - 1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st"}
    }
    
    let(:test_round) {
        Round.create(test_all)
    }
    
    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing


    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:valid_req) {
        {round_type: "Qualifying", score_method: "Points"}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "100th US Nationals - 1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", round_type: "Match", score_method: "Set", rank: "Win"}
    }

    # every attr blank
    let(:blank) {
        {name: "", round_type: "", score_method: "", rank: ""}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"100th US Nationals - 1440 Round"}
    # let(:default_attr) {}
  
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
                round = Round.create(valid_req)

                expect(round).to be_valid
                expect(Round.all.count).to eq(1)

                # req input tests (should have value in valid_req)
                expect(round.round_type).to eq(valid_req[:round_type])
                expect(round.score_method).to eq(valid_req[:score_method])

                # not req input tests (name auto-asigned from missing)
                expect(round.name).to eq(assigned_name)
                expect(round.rank).to be_nil
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
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                round = Round.create(blank)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(0)

                # expect(round.errors.messages[:name]).to include(default_missing_message)
                # expect(round.name).to eq(assigned_name)
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
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            @round = Round.create(duplicate)
            
            # this is because of auto-assign feature keeps creating new objects, so now only called once
            @end = valid_end
            
            # this needs to always run before creating an archer so validations work (creates inclusion lists)
            before_archer

            @shot = Shot.create(
                archer: valid_archer, 
                score_session: valid_score_session, 
                round: @round, 
                rset: valid_rset, 
                end: @end, 
                number: 5, 
                score_entry: "1"
            )
        end

        it "has many Archers" do
            expect(@round.archers).to include(valid_archer)
            expect(valid_archer.rounds).to include(@round)
        end

        it "has many ScoreSessons" do
            expect(@round.score_sessions).to include(valid_score_session)
            expect(valid_score_session.rounds).to include(@round)
        end

        it "has many Rsets" do
            expect(@round.rsets).to include(valid_rset)
            expect(valid_rset.rounds).to include(@round)
        end

        it "has many Ends" do
            expect(@round.ends).to include(@end)
            expect(@end.rounds).to include(@round)
        end
    
        it "has many Shots" do
            expect(@round.shots).to include(@shot)
            expect(@shot.round).to eq(@round)
        end
    
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

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_round).to be_invalid
        end
    end
end
