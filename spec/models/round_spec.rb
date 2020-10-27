require 'rails_helper'

RSpec.describe Round, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
            name: "100th US Nationals - 1440 Round", 
            round_type: "Qualifying", 
            score_method: "Points", 
            rank: "1st", 
            archer_id: 1, 
            score_session_id: 1
        }
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
        {round_type: "Qualifying", score_method: "Points", archer_id: 1, score_session_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "100th US Nationals - 1440 Round", round_type: "Qualifying", score_method: "Points", rank: "1st", archer_id: 1, score_session_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", round_type: "Match", score_method: "Set", rank: "Win", archer_id: 1, score_session_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", round_type: "", score_method: "", rank: "", archer_id: "", score_session_id: ""}
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
        before(:each) do
            # this needs to always run before creating an archer so validations work (creates inclusion lists)
            before_archer
            valid_archer
            valid_score_session
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
            valid_archer
            valid_score_session
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
            before(:each) do
                valid_round
            end

            it "can find an associated object" do
                expect(valid_round.rsets).to include(valid_rset)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round = Round.create(duplicate)

                check_rset_attrs = {
                    name: "1440 Round - Set/Distance1", 
                    date: "2020-09-01", 
                    score_session: valid_score_session
                }
                check_rset = round.rsets.create(check_rset_attrs)
                
                expect(round.rsets).to include(check_rset)
                expect(round.rsets.last.name).to eq(check_rset.name)
            end
            
            it "can re-assign instance via the associated object" do
                round = Round.create(duplicate)
                assoc_rset = valid_rset
                expect(valid_round.rsets).to include(assoc_rset)

                assoc_rset.round = round
                assoc_rset.save

                expect(valid_round.rsets).not_to include(assoc_rset)
                expect(round.rsets).to include(assoc_rset)
            end
        end

        describe "has many Ends and" do
            it "can find an associated object" do
                expect(valid_round.ends).to include(valid_end)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round = Round.create(duplicate)

                check_end_attrs = {
                    number: 2, 
                    set_score: ""
                }
                check_end = round.ends.create(check_end_attrs)
                
                expect(round.ends).to include(check_end)
                expect(round.ends.last.number).to eq(check_end.number)
            end
            
            it "can re-assign instance via the associated object" do
                round = Round.create(duplicate)
                assoc_end = valid_end
                expect(valid_round.ends).to include(assoc_end)

                assoc_end.round = round
                assoc_end.save

                expect(valid_round.ends).not_to include(assoc_end)
                expect(round.ends).to include(assoc_end)
            end
        end

        describe "has many Shots and" do
            it "can find an associated object" do
                expect(valid_round.shots).to include(valid_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round = Round.create(duplicate)

                check_shot_attrs = {
                    number: 1, 
                    score_entry: "X"
                }
                check_shot = round.shots.create(check_shot_attrs)
                
                expect(round.shots).to include(check_shot)
                expect(round.shots.last.score_entry).to eq(check_shot.score_entry)
            end
            
            it "can re-assign instance via the associated object" do
                round = Round.create(duplicate)
                assoc_shot = valid_shot
                expect(valid_round.shots).to include(assoc_shot)

                assoc_shot.round = round
                assoc_shot.save

                expect(valid_round.shots).not_to include(assoc_shot)
                expect(round.shots).to include(assoc_shot)
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
        it "helpers TBD" do
            pending "add as needed"
            expect(test_round).to be_valid
        end
    end
end
