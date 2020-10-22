require 'rails_helper'

RSpec.describe Target, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "80cm/1-spot/10-ring", size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}
    }

    let(:test_target) {
        Target.create(test_all)
    }
    
    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing


    # ###################################################################
    # define standard create/update variations
    # ###################################################################

    # take test_all and remove any non-required atts and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "80cm/1-spot/10-ring", size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3}
    }

    # every attr blank
    let(:blank) {
        {name: "", size: "", score_areas: "", rings: "", x_ring: "", max_score: "", spots: "", user_edit: ""}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"80cm/1-spot/10-ring"}
    let(:assigned_name_update) {"40cm/3-spot/6-ring"}
    let(:default_user_edit) {true}

    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_size_message) {"You must provide a target size."}
    let(:missing_score_areas_message) {"You must provide the number of scoring areas."}
    let(:missing_rings_message) {"You must provide the number of rings."}
    let(:missing_x_ring_message) {"You must specifiy if there is an X ring."}
    let(:missing_max_score_message) {"You must provide the higest score value."}
    let(:missing_spots_message) {"You must specify the number of spots."}


    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when" do
            it "given all required and unrequired attributes" do
                expect(Target.all.count).to eq(0)

                expect(test_target).to be_valid
                expect(Target.all.count).to eq(1)

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
                expect(Target.all.count).to eq(0)
                target = Target.create(test_req)

                expect(target).to be_valid
                expect(Target.all.count).to eq(1)

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
                
                # req input tests (should have value in test_req)
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
                target = Target.create(blank)

                expect(target).to be_invalid
                expect(Target.all.count).to eq(0)

                expect(target.errors.messages[:size]).to include(missing_size_message)
                expect(target.errors.messages[:score_areas]).to include(missing_score_areas_message)
                expect(target.errors.messages[:rings]).to include(missing_rings_message)
                expect(target.errors.messages[:x_ring]).to include(missing_x_ring_message)
                expect(target.errors.messages[:max_score]).to include(missing_max_score_message)
                expect(target.errors.messages[:spots]).to include(missing_spots_message)
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_target
                expect(Target.all.count).to eq(1)
                target = Target.create(duplicate)

                expect(target).to be_invalid
                expect(Target.all.count).to eq(1)
                expect(target.errors.messages[:name]).to include(default_duplicate_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load test object
            test_target

            # load all AssocModels that must be in DB for tests to work
            valid_archer
            valid_category
            valid_dist_targ_cat
        end

        it "has many Archers" do
            expect(test_target.archers).to include(valid_archer)
        end

        it "has many ArcherCategories" do
            expect(test_target.archer_categories).to include(valid_category)
        end
    end
end

