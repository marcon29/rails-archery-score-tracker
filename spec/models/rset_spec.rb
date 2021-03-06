require 'rails_helper'

RSpec.describe Rset, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
            name: "2020 World Cup - 1440 Round - Set/Distance2", 
            date: "2020-09-01", 
            rank: "1st", 
            archer_id: 1, 
            score_session_id: 1, 
            round_id: 1, 
            set_end_format_id: 2, 
            distance_target_category_id: 1
        }
    }

    let(:test_rset) {
        Rset.create(test_all)
    }

    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing
    let(:second_set_end_format_attrs) {
        {num_ends: 6, shots_per_end: 6, user_edit: false, round_format: valid_round_format}
    }

    let(:second_set_end_format) {
        Format::SetEndFormat.create(second_set_end_format_attrs)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {date: "2020-09-01", archer_id: 1, score_session_id: 1, round_id: 1, set_end_format_id: 2}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "2020 World Cup - 1440 Round - Set/Distance2", date: "2020-09-01", rank: "1st", archer_id: 1, score_session_id: 1, round_id: 1, set_end_format_id: 2, distance_target_category_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {date: "2020-09-05", rank: "3rd", archer_id: 1, score_session_id: 1, round_id: 1, set_end_format_id: 2}
    }

    # every attr blank
    let(:blank) {
        {date: "", rank: "", archer_id: 1, score_session_id: 1, round_id: 1, set_end_format_id: 2}
    }
    
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"2020 World Cup - 1440 Round - Set/Distance2"}
    let(:assigned_name_dupe) {"2020 World Cup - 720 Round - Set/Distance1"}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_date_message) {"You must choose a start date."}
    let(:inclusion_date_message) {"Date must be between #{valid_score_session.start_date} and #{valid_score_session.end_date}."}
    let(:inclusion_rank_message) {'Enter only a number above 0, "W" or "L".'}


    # ###################################################################
    # define tests
    # ###################################################################
    
    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            before_rset
            second_set_end_format
            valid_rset
            valid_dist_targ_cat_alt
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Rset.all.count).to eq(1)

                expect(test_rset).to be_valid
                expect(Rset.all.count).to eq(2)
                
                expect(test_rset.name).to eq(test_all[:name])
                expect(test_rset.date).to eq(test_all[:date].to_date)
                expect(test_rset.rank).to eq(test_all[:rank])
            end

            it "given only required attributes" do                
                expect(Rset.all.count).to eq(1)
                rset = Rset.create(test_req)

                expect(rset).to be_valid
                expect(Rset.all.count).to eq(2)

                # req input tests (should have value in test_req)
                expect(rset.date).to eq(test_req[:date].to_date)
                
                # not req input tests (name auto-asigned from missing)
                expect(rset.name).to eq(assigned_name)
                expect(rset.rank).to be_nil
            end

            it "name is duplicated but for different Round" do
                # need second round format (for second round)
                second_round_format = Format::RoundFormat.create(name: "720 Round", num_sets: 1, user_edit: false)

                # need second set end format (for second rset)
                other_set_end_format = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, user_edit: false, round_format: second_round_format)

                # need second round
                second_round = Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "1st", archer: valid_archer, score_session: valid_score_session, round_format: second_round_format, archer_category: valid_category)
                expect(Round.all.count).to eq(2)
                expect(Rset.all.count).to eq(1)

                # gives me 2nd rset in valid_round
                test_rset
                expect(Rset.all.count).to eq(2)
                
                # gives me third DTC so third Rset will be valid 
                Organization::DistanceTargetCategory.create(set_end_format_id: 3, archer_category_id: 1, distance: "90m", target_id: 1)

                # gives me 1 rset in second_round with same name as rset in first_round
                update[:round_id] = 2
                update[:set_end_format_id] = 3
                rset = Rset.create(update)

                expect(rset).to be_valid
                expect(Rset.all.count).to eq(3)
                expect(rset.name).to eq(assigned_name_dupe)
                expect(rset.date).to eq(update[:date].to_date)
                expect(rset.rank).to eq(update[:rank])
            end

            it "updating all attributes" do
                test_rset.update(update)
                
                # req input tests (should have value in update)
                expect(test_rset.date).to eq(update[:date].to_date)
                expect(test_rset.rank).to eq(update[:rank])
            end

            it "all associated objects have the same parents" do
                expect(test_rset.check_associations.count).to eq(3)
                expect(test_rset.check_associations).not_to include(false)
                expect(test_rset).to be_valid
            end
        end
    
        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                expect(Rset.all.count).to eq(1)
                rset = Rset.create(blank)

                expect(rset).to be_invalid
                expect(Rset.all.count).to eq(1)
                
                expect(rset.name).to eq(assigned_name)
                expect(rset.errors.messages[:date]).to include(missing_date_message)
                expect(rset.rank).to be_blank
            end
            
            it "unique attributes are duplicated" do
                expect(Rset.all.count).to eq(1)
                test_rset
                expect(Rset.all.count).to eq(2)
                rset = Rset.create(duplicate)

                expect(rset).to be_invalid
                expect(Rset.all.count).to eq(2)
                expect(rset.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "exceeds the total number of Rsets allowable for the Round" do
                valid_round_format.num_sets.times { Format::SetEndFormat.create(second_set_end_format_attrs) }
                expect(Format::SetEndFormat.all.count).to eq(4)

                Format::SetEndFormat.all.each do |sef|
                    test_req[:set_end_format_id] = sef.id
                    Organization::DistanceTargetCategory.create(set_end_format_id: sef.id, archer_category_id: 1, distance: "70m", target_id: 1)
                    Rset.create(test_req)
                end
                expect(Rset.all.count).to eq(4)

                rset = Rset.create(test_req)

                expect(rset).to be_invalid
                expect(Rset.all.count).to eq(4)
                expect(rset.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "date is outside allowable inputs" do
                expect(Rset.all.count).to eq(1)
                bad_scenarios = ["2020-08-31", "2020-09-06"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:date] = test_value
                    rset = Rset.create(duplicate)
                    expect(rset).to be_invalid
                    expect(Rset.all.count).to eq(1)
                    expect(rset.errors.messages[:date]).to include(inclusion_date_message)
                end
            end

            it "rank is outside allowable inputs" do
                expect(Rset.all.count).to eq(1)
                bad_scenarios = ["0", "000", "00text", "00st", "-1", "first", "winner", "loser"]

                bad_scenarios.each do | test_value |
                    duplicate[:rank] = test_value
                    rset = Rset.create(duplicate)
                    expect(rset).to be_invalid
                    expect(Rset.all.count).to eq(1)
                    
                    expect(rset.errors.messages[:rank]).to include(inclusion_rank_message)
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
                test_rset.update(score_session: second_score_session)

                expect(test_rset).to be_invalid
                expect(test_rset.errors.messages).to be_present
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            before_rset
            second_set_end_format
            valid_dist_targ_cat_alt
        end

        describe "belongs to an Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_rset.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                test_req[:archer_id] = ""
                check_rset = assoc_archer.rsets.create(test_req)
                
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
                test_req[:score_session_id] = ""
                check_rset = assoc_score_session.rsets.create(test_req)
                
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
                test_req[:round_id] = ""
                check_rset = assoc_round.rsets.create(test_req)
                
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

                check_end_attrs = {set_score: 2, archer_id: 1, score_session_id: 1, round_id: 1}
                check_end = rset.ends.create(check_end_attrs)
                
                expect(rset.ends).to include(check_end)
                expect(rset.ends.last.number).to eq(check_end.number)
            end
        end

        describe "has many Shots and" do
            before(:each) do
                before_shot
            end

            it "can find an associated object" do
                expect(valid_rset.shots).to include(valid_shot)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                rset = Rset.create(duplicate)

                check_shot_attrs = {score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, end_id: 1}
                check_shot = rset.shots.create(check_shot_attrs)
                
                expect(rset.shots).to include(check_shot)
                expect(rset.shots.last.score_entry).to eq(check_shot.score_entry)
            end
        end

        describe "belongs to a SetEndFormat and" do
            it "can find an associated object" do
                assoc_set_end_format = second_set_end_format
                expect(test_rset.set_end_format).to eq(assoc_set_end_format)
            end
        end

        describe "belongs to a DistanceTargetCategory and" do
            it "can find an associated object" do
                valid_dist_targ_cat_alt
                rset = Rset.create(test_req)
                expect(rset.distance_target_category).to eq(valid_dist_targ_cat_alt)
            end
        end

        describe "has one Target and" do
            it "find an associated object when only having primary target" do
                expect(valid_rset.target).to eq(valid_target)
            end

            it "find an associated object when having an alternate target" do
                valid_rset
                test_rset
                expect(test_rset.target).to eq(valid_target)
                expect(test_rset.alt_target).to eq(valid_target_alt)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            before_rset
            second_set_end_format
            valid_dist_targ_cat_alt
        end

        describe "methods primarily for callbacks and validations" do
            it "can identify the ArcherCategory of the Round it belongs to" do
                expect(test_rset.archer_category).to eq(valid_category)
            end

            it "can find the DistanceTargetCategory it should have from Round data" do
                expect(valid_rset.find_dist_targ_cat).to eq(valid_dist_targ_cat)
            end
        end

        describe "methods primarily for getting useful data" do
            it "can identify the distance for itself" do
                expect(test_rset.distance).to eq(valid_dist_targ_cat_alt.distance)
            end

            it "can identify the RoundFormat of the Round it belongs to" do
                pending "not sure if I need this - method in model file, commented out"
                expect(test_rset.round_format).to eq(valid_round_format)
            end

            it "can identify the number of ends it should have from SetEndFormat" do
                expect(test_rset.num_ends).to eq(valid_set_end_format.num_ends)
            end

            it "can identify the number of shots its ends should have from SetEndFormat" do
                expect(test_rset.shots_per_end).to eq(valid_set_end_format.shots_per_end)
            end

            it "can calculate the total score for a set" do
                before_shot
                Rset.destroy_all
                End.destroy_all
                Shot.destroy_all

                rset = Rset.create(test_req)

                expect(Rset.all.count).to eq(1)
                expect(End.all.count).to eq(0)
                expect(Shot.all.count).to eq(0)
                
                first_end = End.create(archer_id: 1, score_session_id: 1, round_id: 1, rset: rset)
                second_end = End.create(archer_id: 1, score_session_id: 1, round_id: 1, rset: rset)
                expect(End.all.count).to eq(2)
                expect(rset.ends.count).to eq(2)

                Shot.create(score_entry: "X", archer_id: 1, score_session_id: 1, round_id: 1, rset: rset, end: first_end)
                Shot.create(score_entry: "10", archer_id: 1, score_session_id: 1, round_id: 1, rset: rset, end: first_end)
                Shot.create(score_entry: "M", archer_id: 1, score_session_id: 1, round_id: 1, rset: rset, end: first_end)
                Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, rset: rset, end: second_end)
                Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, rset: rset, end: second_end)
                Shot.create(score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, rset: rset, end: second_end)
                expect(Shot.all.count).to eq(6)
                expect(rset.shots.count).to eq(6)
                
                expect(rset.score).to eq(35)
            end
        end
    end
end
