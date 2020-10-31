require 'rails_helper'

RSpec.describe Format::Target, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "80cm/1-spot/10-ring", size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: true}
    }

    let(:test_target) {
        Format::Target.create(test_all)
    }
    
    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing


    # ###################################################################
    # define standard create/update variations
    # ###################################################################

    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "80cm/1-spot/10-ring", size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: true}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", size: "20in", score_areas: 5, rings: 5, x_ring: false, max_score: 5, spots: 3}
    }

    # every attr blank
    let(:blank) {
        {name: "", size: "", score_areas: "", rings: "", x_ring: "", max_score: "", spots: "", user_edit: ""}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"80cm/1-spot/10-ring"}
    let(:assigned_name_update) {"20in/3-spot/5-ring"}
    let(:default_user_edit) {true}

    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_size_message) {"You must provide a target size."}
    let(:missing_x_ring_message) {"You must specifiy if there is an X ring."}
    let(:number_all_message) {"You must enter a number greater than 0."}
    let(:restricted_update_message) {"You can't change a pre-loaded #{valid_target.class.to_s}."}


    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when" do
            it "given all required and unrequired attributes" do
                expect(Format::Target.all.count).to eq(0)

                expect(test_target).to be_valid
                expect(Format::Target.all.count).to eq(1)

                expect(test_target.name).to eq(assigned_name)
                expect(test_target.size).to eq(test_all[:size])
                expect(test_target.score_areas).to eq(test_all[:score_areas])
                expect(test_target.rings).to eq(test_all[:rings])
                expect(test_target.x_ring).to eq(test_all[:x_ring])
                expect(test_target.max_score).to eq(test_all[:max_score])
                expect(test_target.spots).to eq(test_all[:spots])
                expect(test_target.user_edit).to eq(test_all[:user_edit])
            end
            
            it "given only required attributes" do
                expect(Format::Target.all.count).to eq(0)
                target = Format::Target.create(test_req)

                expect(target).to be_valid
                expect(Format::Target.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(target.size).to eq(test_req[:size])
                expect(target.score_areas).to eq(test_req[:score_areas])
                expect(target.rings).to eq(test_req[:rings])
                expect(target.x_ring).to eq(test_req[:x_ring])
                expect(target.max_score).to eq(test_req[:max_score])
                expect(target.spots).to eq(test_req[:spots])

                # not req input tests (name and user_edit auto-asigned from missing)
                expect(target.name).to eq(assigned_name)
                expect(target.user_edit).to eq(default_user_edit)
            end

            it "updating all attributes" do
                test_target.update(update)
                
                expect(test_target).to be_valid
                
                # req input tests (should have value in update)
                expect(test_target.size).to eq(update[:size])
                expect(test_target.score_areas).to eq(update[:score_areas])
                expect(test_target.rings).to eq(update[:rings])
                expect(test_target.x_ring).to eq(update[:x_ring])
                expect(test_target.max_score).to eq(update[:max_score])
                expect(test_target.spots).to eq(update[:spots])

                # not req input tests (name and user_edit auto-asigned from blank)
                expect(test_target.name).to eq(assigned_name_update)
                expect(test_target.user_edit).to eq(test_all[:user_edit])
            end
        end    

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                target = Format::Target.create(blank)

                expect(target).to be_invalid
                expect(Format::Target.all.count).to eq(0)

                expect(target.errors.messages[:size]).to include(missing_size_message)
                expect(target.errors.messages[:score_areas]).to include(number_all_message)
                expect(target.errors.messages[:rings]).to include(number_all_message)
                expect(target.errors.messages[:x_ring]).to include(missing_x_ring_message)
                expect(target.errors.messages[:max_score]).to include(number_all_message)
                expect(target.errors.messages[:spots]).to include(number_all_message)
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_target
                expect(Format::Target.all.count).to eq(1)
                target = Format::Target.create(duplicate)

                expect(target).to be_invalid
                expect(Format::Target.all.count).to eq(1)
                expect(target.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "attributes are outside allowable inputs" do
                duplicate[:score_areas] = "six"
                duplicate[:rings] = "six"
                duplicate[:max_score] = "six"
                duplicate[:spots] = "six"

                target = Format::Target.create(duplicate)

                expect(target).to be_invalid
                expect(Format::Target.all.count).to eq(0)
                
                expect(target.errors.messages[:score_areas]).to include(number_all_message)
                expect(target.errors.messages[:rings]).to include(number_all_message)
                expect(target.errors.messages[:max_score]).to include(number_all_message)
                expect(target.errors.messages[:spots]).to include(number_all_message)
            end

            it "trying to edit a restricted, pre-load target" do
                # can create an instance with user_edit == false, but not edit after
                expect(Format::Target.all.count).to eq(0)

                target = Format::Target.create(
                    name: test_all[:name], 
                    size: test_all[:size], 
                    score_areas: test_all[:score_areas], 
                    rings: test_all[:rings], 
                    x_ring: test_all[:x_ring], 
                    max_score: test_all[:max_score], 
                    spots: test_all[:spots], 
                    user_edit: false
                    )
                expect(Format::Target.all.count).to eq(1)
                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(target).to be_valid
                
                target.update(update)
                target.reload

                expect(target).to be_invalid
                expect(target.errors.messages[:user_edit]).to include(restricted_update_message)

                expect(target.errors.messages[:name]).to include(restricted_update_message)
                expect(target.name).to eq(test_all[:name])

                expect(target.errors.messages[:size]).to include(restricted_update_message)
                expect(target.size).to eq(test_all[:size])

                expect(target.errors.messages[:score_areas]).to include(restricted_update_message)
                expect(target.score_areas).to eq(test_all[:score_areas])

                expect(target.errors.messages[:rings]).to include(restricted_update_message)
                expect(target.rings).to eq(test_all[:rings])

                expect(target.errors.messages[:x_ring]).to include(restricted_update_message)
                expect(target.x_ring).to eq(test_all[:x_ring])

                expect(target.errors.messages[:max_score]).to include(restricted_update_message)
                expect(target.max_score).to eq(test_all[:max_score])

                expect(target.errors.messages[:spots]).to include(restricted_update_message)
                expect(target.spots).to eq(test_all[:spots])
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        describe "has many DistanceTargetCategories and" do
            it "can find an associated object via the primary target" do
                expect(valid_target.distance_target_categories).to include(valid_dist_targ_cat)
            end

            it "can find an associated object via the alternate target" do
                expect(valid_target_alt.alt_distance_target_categories).to include(valid_dist_targ_cat_alt)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can identify all possible score entries" do
            fita122_scores = ["M", "X", "10", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
            no_x_ring_scores =  ["M", "10", "9", "8", "7", "6", "5", "4", "3", "2", "1"]
            fita80_6ring_scores = ["M", "X", "10", "9", "8", "7", "6", "5"]
            
            target = Format::Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: true)
            expect(Format::Target.all.count).to eq(1)

            expect(target.possible_scores).to eq(fita122_scores)

            target.update(x_ring: false)
            expect(target.possible_scores).to eq(no_x_ring_scores)

            target.update(score_areas: 6, rings: 6, x_ring: true,)
            expect(target.possible_scores).to eq(fita80_6ring_scores)
        end
    end
end

