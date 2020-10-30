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
            set_end_format_id: 2
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
        {name: "2020 World Cup - 1440 Round - Set/Distance2", date: "2020-09-01", rank: "1st", archer_id: 1, score_session_id: 1, round_id: 1, set_end_format_id: 2}
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
                second_round = Round.find_or_create_by(round_type: "Qualifying", score_method: "Points", rank: "1st", archer: valid_archer, score_session: valid_score_session, round_format: second_round_format)
                expect(Round.all.count).to eq(2)
                expect(Rset.all.count).to eq(1)

                # gives me 2nd rset in valid_round
                test_rset
                expect(Rset.all.count).to eq(2)
                
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
                Format::SetEndFormat.destroy_all
                Rset.destroy_all
                expect(Format::SetEndFormat.all.count).to eq(0)
                expect(Rset.all.count).to eq(0)

                valid_round_format.num_sets.times { Format::SetEndFormat.create(second_set_end_format_attrs) }
                expect(Format::SetEndFormat.all.count).to eq(4)

                Format::SetEndFormat.all.each do |sef|
                    test_req[:set_end_format_id] = sef.id
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
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            before_rset
            second_set_end_format
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

        describe "belongs to a SetEndFormat and" do
            it "can find an associated object" do
                assoc_set_end_format = second_set_end_format
                expect(test_rset.set_end_format).to eq(assoc_set_end_format)
            end
        end

        describe "sectioning off for Organization concern" do
            it "has one DistanceTargetCategory" do
                pending "need to add create associated models and add associations"
                expect(test_rset.distance_target_category).to eq(valid_category)
            end

            it "has one Target" do
                pending "need to add create associated models and add associations"
                # expect(test_rset.target).to eq(valid_target)
                expect(test_rset.target).to eq(something_to_fail)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            before_rset
            second_set_end_format
        end

        describe "methods primarily for callbacks and validations" do
        end

        describe "methods primarily for getting useful data" do
            it "can identify the RoundFormat of the Round it belongs to" do
                expect(test_rset.round_format).to eq(valid_round_format)
            end

            it "can identify the number of ends it should have from SetEndFormat" do
                expect(test_rset.num_ends).to eq(valid_set_end_format.num_ends)
            end

            it "can identify the number of shots its ends should have from SetEndFormat" do
                expect(test_rset.shots_per_end).to eq(valid_set_end_format.shots_per_end)
            end

            it "can calculate the total score for a set" do
                # want to be able to to call rset.score
                # sums all end scores
                expect(rset.score).to eq(all_ends_scores)
            end
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(rset).to be_invalid
        end
    end
end
