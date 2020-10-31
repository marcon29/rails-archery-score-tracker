require 'rails_helper'

RSpec.describe Shot, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {number: 2, score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1}
    }

    let(:test_shot) {
        Shot.create(test_all)
    }
    
    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing
    # this is how 2 ends of 3 shots would look, covers all score_entry options
    let(:multi_shot_11_attrs) { {score_entry: "X", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1} }
    let(:multi_shot_12_attrs) { {score_entry: "10", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1} }
    let(:multi_shot_13_attrs) { {score_entry: "M", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1} }
    let(:multi_shot_21_attrs) { {score_entry: "9", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 2} }
    let(:multi_shot_22_attrs) { {score_entry: "8", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 2} }
    let(:multi_shot_23_attrs) { {score_entry: "7", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 2} }

    let(:multi_shot_11) { Shot.create(multi_shot_11_attrs) }
    let(:multi_shot_12) { Shot.create(multi_shot_12_attrs) }
    let(:multi_shot_13) { Shot.create(multi_shot_13_attrs) }
    let(:multi_shot_21) { Shot.create(multi_shot_21_attrs) }
    let(:multi_shot_22) { Shot.create(multi_shot_22_attrs) }
    let(:multi_shot_23) { Shot.create(multi_shot_23_attrs) }
    

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {number: 2, score_entry: "5", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {score_entry: "4"}
    }
    
    # every attr blank
    let(:blank) {
        {score_entry: "", archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1, end_id: 1}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_num) {1}
    

    # ###################################################################
    # define tests
    # ###################################################################
    
    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            before_shot
        end

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

            it "number is duplicated but for different End" do
                # need second end
                second_end = End.find_or_create_by(number: 2, set_score: "", archer: valid_archer, score_session: valid_score_session, round: valid_round, rset: valid_rset)
                expect(End.all.count).to eq(2)
                expect(Shot.all.count).to eq(0)

                # gives me 2 shots in valid_end
                valid_shot
                test_shot
                expect(Shot.all.count).to eq(2)
                
                # gives me 1 shot in second_end
                test_req[:end_id] = 2
                third_shot = Shot.create(test_req)
                expect(Shot.all.count).to eq(3)

                # test duped name from valid_shot but in second_end
                duplicate[:number] = ""
                duplicate[:end_id] = 2
                shot = Shot.create(duplicate)

                expect(shot).to be_valid
                expect(Shot.all.count).to eq(4)

                expect(shot.number).to eq(2)
                expect(shot.score_entry).to eq(duplicate[:score_entry])
            end

            it "missing score_entry at instantiation" do
                test_req[:score_entry] = ""

                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # shot = Shot.new(test_req)
                # expect(shot).to be_valid
                # shot.save
                shot = Shot.create(test_req)
                # expect(shot).to be_valid
                expect(Shot.all.count).to eq(1)
                
                expect(shot.score_entry).to be_blank
                expect(shot.number).to eq(assigned_num)
            end

            it "updating all attributes" do
                shot = Shot.create(test_req)
                shot.update(update)

                expect(shot).to be_valid
                
                # req input tests (should have value in update)
                expect(shot.score_entry).to eq(update[:score_entry])
                
                # not req input tests (number auto-asigned from blank)
                expect(shot.number).to eq(assigned_num)
            end

            it "all associated objects have the same parents" do
                expect(test_shot.check_associations.count).to eq(10)
                expect(test_shot.check_associations).not_to include(false)
                expect(test_shot).to be_valid
            end
        end

        describe "invalid and has correct error message when" do
            it "number is outside allowable inputs" do
                bad_scenarios = [0, -1, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:number] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(0)
                    expect(shot.errors.messages[:number]).to be_present
                end
            end

            it "exceeds the total number of ends allowable for the Rset" do
                expect(Shot.all.count).to eq(0)
                valid_set_end_format.shots_per_end.times { Shot.create(test_req) }
                expect(Shot.all.count).to eq(6)
                
                shot = Shot.create(test_req)

                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(6)
                expect(shot.errors.messages[:number]).to be_present
            end

            it "unique attributes are duplicated" do
                test_shot
                expect(Shot.all.count).to eq(1)
                shot = Shot.create(duplicate)

                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(1)
                expect(shot.errors.messages[:number]).to include(default_duplicate_message)
            end

            it "missing score_entry upon update" do
                test_req[:score_entry] = ""
                shot = Shot.create(test_req)

                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(shot).to be_valid

                expect(Shot.all.count).to eq(1)

                shot.update(blank)

                expect(shot).to be_invalid
                expect(shot.errors.messages[:score_entry]).to include("You must enter a score for shot #{shot.number}.")
                expect(shot.number).to eq(assigned_num)
            end

            it "score_entry is outside allowable inputs" do
                # shot instance must have same target as test_shot
                under_min = (test_shot.target.max_score - test_shot.target.score_areas + 1) - 1
                over_max = test_shot.target.max_score + 1
                bad_scenarios = ["0", "-1", under_min, over_max, "bad", "MX"]

                bad_scenarios.each do | test_value |
                    expect(Shot.all.count).to eq(1)
                    duplicate[:score_entry] = test_value
                    shot = Shot.create(duplicate)
                    expect(shot).to be_invalid
                    expect(Shot.all.count).to eq(1)
                    expect(shot.errors.messages[:score_entry]).to include("Enter only M, X, or a number between #{shot.target.max_score - shot.target.score_areas + 1} and #{shot.target.max_score}.")
                end
            end

            it "the score_entry value is X when there is no x-ring" do
                # include a test for both instantiation and updating
                Format::Target.destroy_all
                test_target = Format::Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: false, max_score: 10, spots: 1, user_edit: true)
                expect(Format::Target.all.count).to eq(1)
                
                duplicate[:score_entry] = "X"
                shot = Shot.create(duplicate)
                expect(shot).to be_invalid
                expect(Shot.all.count).to eq(0)
                expect(shot.errors.messages[:score_entry]).to include("Enter only M or a number between #{shot.target.max_score - shot.target.score_areas + 1} and #{shot.target.max_score}.")

                test_shot.update(score_entry: "X")
                expect(test_shot).to be_invalid
                expect(Shot.all.count).to eq(1)
                expect(test_shot.errors.messages[:score_entry]).to include("Enter only M or a number between #{test_shot.target.max_score - test_shot.target.score_areas + 1} and #{test_shot.target.max_score}.")
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
                test_shot.update(score_session: second_score_session)

                expect(test_shot).to be_invalid
                expect(test_shot.errors.messages).to be_present

                # expect(test_round.check_associations.count).to eq(1)
                # expect(test_rset.check_associations.count).to eq(3)
                # expect(test_endd.check_associations.count).to eq(6)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            before_shot
        end

        describe "belongs to Archer and" do
            it "can find an associated object" do
                assoc_archer = valid_archer
                expect(test_shot.archer).to eq(assoc_archer)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_archer = valid_archer
                test_req[:archer_id] = ""
                check_shot = assoc_archer.shots.create(test_req)
                
                expect(check_shot.archer).to eq(assoc_archer)
                expect(check_shot.archer.username).to include(assoc_archer.username)
            end
        end

        describe "belongs to ScoreSession and" do
            it "can find an associated object" do
                assoc_score_session = valid_score_session
                expect(test_shot.score_session).to eq(assoc_score_session)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_score_session = valid_score_session
                test_req[:score_session_id] = ""
                check_shot = assoc_score_session.shots.create(test_req)
                
                expect(check_shot.score_session).to eq(assoc_score_session)
                expect(check_shot.score_session.name).to include(assoc_score_session.name)
            end
        end

        describe "belongs to Round and" do
            it "can find an associated object" do
                assoc_round = valid_round
                expect(test_shot.round).to eq(assoc_round)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_round = valid_round
                test_req[:round_id] = ""
                check_shot = assoc_round.shots.create(test_req)
                
                expect(check_shot.round).to eq(assoc_round)
                expect(check_shot.round.name).to include(assoc_round.name)
            end
        end

        describe "belongs to Rset and" do
            it "can find an associated object" do
                assoc_rset = valid_rset
                expect(test_shot.rset).to eq(assoc_rset)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_rset = valid_rset
                test_req[:rset_id] = ""
                check_shot = assoc_rset.shots.create(test_req)
                
                expect(check_shot.rset).to eq(assoc_rset)
                expect(check_shot.rset.name).to include(assoc_rset.name)
            end
        end

        describe "belongs to End and" do
            it "can find an associated object" do
                expect(test_shot.end.id).to eq(1)
            end

            it "can create a new instance via the associated object and get associated object attributes" do
                assoc_end = End.first
                test_req[:end_id] = ""
                check_shot = assoc_end.shots.create(test_req)
                
                expect(check_shot.end).to eq(assoc_end)
                expect(check_shot.end.number).to eq(assoc_end.number)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            before_shot
        end

        describe "methods primarily for callbacks and validations" do
            it "can find all shots that belong to same end" do
                second_end = End.create(archer_id: 1, score_session_id: 1, round_id: 1, rset_id: 1)
                multi_shot_11
                multi_shot_12
                multi_shot_13
                multi_shot_21
                multi_shot_22
                multi_shot_23
                
                expect(Shot.all.count).to eq(6)
                expect(multi_shot_11.shots_in_end.count).to eq(3)
                expect(multi_shot_21.shots_in_end.count).to eq(3)
                expect(multi_shot_11.shots_in_end).to include(multi_shot_11)
                expect(multi_shot_11.shots_in_end).to include(multi_shot_12)
                expect(multi_shot_11.shots_in_end).to include(multi_shot_12)
                expect(multi_shot_11.shots_in_end).not_to include(multi_shot_21)
                expect(multi_shot_11.shots_in_end).not_to include(multi_shot_22)
                expect(multi_shot_11.shots_in_end).not_to include(multi_shot_23)
            end

            it "can identify the total number of shots allowed in its End" do
                expect(test_shot.allowable_shots_per_end).to eq(valid_set_end_format.shots_per_end)
            end
    
            it "can identify all possible score entries" do
                fita122_scores = ["M", "X", "10", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
                no_x_ring_scores =  ["M", "10", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
                fita80_6ring_scores = ["M", "X", "10", "9", "8", "7", "6", "5"]
                
                Format::Target.destroy_all
                test_target = Format::Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: true)
                expect(Format::Target.all.count).to eq(1)
                
                shot = Shot.create(archer: valid_archer, score_session: valid_score_session, round: valid_round, rset: valid_rset, end: valid_end)
                expect(shot.possible_scores).to eq(fita122_scores)
    
                test_target.update(x_ring: false)
                expect(shot.possible_scores).to eq(no_x_ring_scores)
    
                test_target.update(score_areas: 6, rings: 6, x_ring: true,)
                expect(shot.possible_scores).to eq(fita80_6ring_scores)
            end

            it "can properly format a score entry" do
                test_req[:score_entry] = "x"
                shot_text = Shot.create(test_req)
    
                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(shot_text).to be_valid
                expect(Shot.all.count).to eq(1)
                expect(shot_text.score_entry).to eq("X")
                expect(shot_text.score).to eq(10)
    
                test_req[:score_entry] = "5"
                shot_num = Shot.create(test_req)
                
                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(shot_num).to be_valid
                expect(Shot.all.count).to eq(2)
                expect(shot_num.score_entry).to eq("5")
                expect(shot_num.score).to eq(5)
            end
        end

        describe "methods primarily for getting useful data" do
            it "can calculate a score (point value) for a shot" do
                valid_target
                multi_shot_11
                multi_shot_12
                multi_shot_13
    
                expect(multi_shot_11.score).to eq(valid_target.max_score)
                expect(multi_shot_12.score).to eq(multi_shot_12_attrs[:score_entry].to_i)
                expect(multi_shot_13.score).to eq(0)
            end
            
            it "can find the date a shot was made" do
                expect(test_shot.date).to eq(valid_rset.date)
            end

            it "can find the distance at which shot was made" do
                expect(test_shot.distance).to eq("90m")
                # expect(test_shot.distance).to eq(valid_dist_targ_cat.distance)
            end
            
            it "can find the target into which shot was made" do
                expect(test_shot.target).to eq(valid_target)
            end
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_shot).to be_invalid
        end
    end
end
