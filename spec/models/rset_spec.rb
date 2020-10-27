require 'rails_helper'

RSpec.describe Rset, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
            name: "1440 Round - Set/Distance2", 
            date: "2020-09-01", 
            rank: "1st", 
            archer_id: 1, 
            score_session_id: 1, 
            round_id: 1
        }
    }

    let(:test_rset) {
        Rset.create(test_all)
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
        {date: "2020-09-01", archer_id: 1, score_session_id: 1, round_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "1440 Round - Set/Distance2", date: "2020-09-01", rank: "1st", archer_id: 1, score_session_id: 1, round_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", date: "2020-09-05", rank: "3rd", archer_id: 1, score_session_id: 1, round_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", date: "", rank: "", archer_id: "", score_session_id: "", round_id: ""}
    }
    
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"1440 Round - Set/Distance2"}
    # let(:assigned_name_update) {"40cm/3-spot/6-ring"}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_date_message) {"You must choose a start date."}
    
    let(:inclusion_date_message) {"Date must be between #{valid_score_session.start_date} and #{valid_score_session.end_date}."}
    let(:inclusion_rank_message) {'Enter only a number above 0, "W" or "L".'}
    
    
    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            # this needs to always run before creating an archer so validations work (creates inclusion lists)
            before_archer
            valid_archer
            valid_score_session
            valid_round
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Rset.all.count).to eq(0)

                expect(test_rset).to be_valid
                expect(Rset.all.count).to eq(1)
                
                expect(test_rset.name).to eq(test_all[:name])
                expect(test_rset.date).to eq(test_all[:date].to_date)
                expect(test_rset.rank).to eq(test_all[:rank])
            end

            it "given only required attributes" do
                expect(Rset.all.count).to eq(0)
                rset = Rset.create(valid_req)

                expect(rset).to be_valid
                expect(Rset.all.count).to eq(1)

                # req input tests (should have value in valid_req)
                expect(rset.date).to eq(valid_req[:date].to_date)
                
                # not req input tests (name auto-asigned from missing)
                expect(rset.name).to eq(assigned_name)
                expect(rset.rank).to be_nil
            end

            it "updating all attributes" do
                test_rset.update(update)
                
                # req input tests (should have value in update)
                expect(test_rset.date).to eq(update[:date].to_date)
                expect(test_rset.rank).to eq(update[:rank])
                
                # not req input tests (active auto-asigned from blank)
                expect(test_rset.name).to eq(assigned_name)
            end
        end
    
        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                rset = Rset.create(blank)

                expect(rset).to be_invalid
                expect(Rset.all.count).to eq(0)
                
                # expect(rset.errors.messages[:name]).to include(default_missing_message)
                # expect(rset.name).to eq(assigned_name)
                expect(rset.errors.messages[:date]).to include(missing_date_message)
                expect(rset.rank).to be_blank
            end
            
            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_rset
                expect(Rset.all.count).to eq(1)
                rset = Rset.create(duplicate)

                expect(rset).to be_invalid
                expect(Rset.all.count).to eq(1)
                expect(rset.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "date is outside allowable inputs" do
                bad_scenarios = ["2020-08-31", "2020-09-06"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:date] = test_value
                    rset = Rset.create(duplicate)
                    expect(rset).to be_invalid
                    expect(Rset.all.count).to eq(0)
                    expect(rset.errors.messages[:date]).to include(inclusion_date_message)
                end
            end

            it "rank is outside allowable inputs" do
                bad_scenarios = ["0", "000", "00text", "00st", "-1", "first", "winner", "loser"]

                bad_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    rset = Rset.create(duplicate)
                    expect(rset).to be_invalid
                    expect(Rset.all.count).to eq(0)
                    
                    expect(rset.errors.messages[:rank]).to include(inclusion_rank_message)
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            valid_archer
            valid_score_session
            valid_round
        end

        describe "belongs to an Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_rset.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                update[:archer_id] = ""
                check_rset = assoc_archer.rsets.create(update)
                
                expect(check_rset.archer).to eq(assoc_archer)
                expect(check_rset.archer.username).to include(assoc_archer.username)
            end
        end

        describe "belongs to a ScoreSession and" do
            it "can find an associated object" do
                assoc_score_session = valid_score_session
                expect(test_rset.score_session).to eq(assoc_score_session)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_score_session = valid_score_session
                update[:score_session_id] = ""
                check_rset = assoc_score_session.rsets.create(update)
                
                expect(check_rset.score_session).to eq(assoc_score_session)
                expect(check_rset.score_session.name).to include(assoc_score_session.name)
            end
        end

        describe "belongs to a Round and" do
            it "can find an associated object" do
                assoc_round = valid_round
                expect(test_rset.round).to eq(assoc_round)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_round = valid_round
                update[:round_id] = ""
                check_rset = assoc_round.rsets.create(update)
                
                expect(check_rset.round).to eq(assoc_round)
                expect(check_rset.round.name).to include(assoc_round.name)
            end
        end

        describe "has many Ends and" do
            it "can find an associated object" do
                expect(valid_rset.ends).to include(valid_end)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                rset = Rset.create(duplicate)

                check_end_attrs = {
                    number: 2, 
                    set_score: ""
                }
                check_end = rset.ends.create(check_end_attrs)
                
                expect(rset.ends).to include(check_end)
                expect(rset.ends.last.number).to eq(check_end.number)
            end
            
            it "can re-assign instance via the associated object" do
                rset = Rset.create(duplicate)
                assoc_end = valid_end
                expect(valid_rset.ends).to include(assoc_end)

                assoc_end.rset = rset
                assoc_end.save

                expect(valid_rset.ends).not_to include(assoc_end)
                expect(rset.ends).to include(assoc_end)
            end
        end

        describe "has many Shots and" do
            it "can find an associated object" do
                expect(valid_rset.shots).to include(valid_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                rset = Rset.create(duplicate)

                check_shot_attrs = {
                    number: 1, 
                    score_entry: "X"
                }
                check_shot = rset.shots.create(check_shot_attrs)
                
                expect(rset.shots).to include(check_shot)
                expect(rset.shots.last.score_entry).to eq(check_shot.score_entry)
            end
            
            it "can re-assign instance via the associated object" do
                rset = Rset.create(duplicate)
                assoc_shot = valid_shot
                expect(valid_rset.shots).to include(assoc_shot)

                assoc_shot.rset = rset
                assoc_shot.save

                expect(valid_rset.shots).not_to include(assoc_shot)
                expect(rset.shots).to include(assoc_shot)
            end
        end

        describe "sectioning off for Organization concern" do
            it "has one DistanceTargetCategory" do
                pending "need to add create associated models and add associations"
                expect(test_rset.distance_target_category).to eq(valid_category)
            end

            it "has one Target" do
                pending "need to add create associated models and add associations"
                expect(test_rset.target).to eq(valid_target)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_rset).to be_invalid
        end
    end
end
