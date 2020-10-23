require 'rails_helper'

RSpec.describe Rset, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "1440 Round - Set/Distance2", date: "2020-09-01", rank: "1st"}
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
        {date: "2020-09-01"}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "1440 Round - Set/Distance2", date: "2020-09-01", rank: "1st"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", date: "2020-09-05", rank: "3rd"}
    }

    # every attr blank
    let(:blank) {
        {name: "", date: "", rank: ""}
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
            # load test object
            
            # load all AssocModels that must be in DB for tests to work
            valid_score_session
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

                # req input tests
                expect(rset.date).to eq(valid_req[:date].to_date)
                
                # not req input tests (name auto-asigned from missing)
                expect(rset.rank).to be_nil
                expect(rset.name).to eq(assigned_name)
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
                
                expect(rset.errors.messages[:date]).to include(missing_date_message)
                expect(rset.rank).to be_blank
            end
            
            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_rset
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
            # load test object
            
            # load all AssocModels that must be in DB for tests to work
        end

        it "has one Archer" do
            pending "need to add create associated models and add associations"
            expect(test_rset.archer).to include(valid_archer)
        end

        it "has one ScoreSesson" do
            pending "need to add create associated models and add associations"
            expect(test_rset.score_session).to include(valid_score_session)
        end

        it "has one Round" do
            pending "need to add create associated models and add associations"
            expect(test_rset.round).to include(valid_round)
        end

        it "has many Ends" do
            pending "need to add create associated models and add associations"
            expect(test_rset.ends).to include(valid_end)
        end
    
        it "has many Shots" do
            pending "need to add create associated models and add associations"
            expect(test_rset.shots).to include(valid_shot)
        end

        it "has one DistanceTargetCategory" do
            expect(test_rset.distance_target_category).to include(valid_category)
        end

        it "has one Target" do
            expect(test_rset.target).to include(valid_target)
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
