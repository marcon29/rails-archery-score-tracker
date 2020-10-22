require 'rails_helper'

RSpec.describe DistanceTargetCategory, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {distance: "70m", target_id: 1, archer_category_id: 1, archer_id: 1}
    }
        
    let(:test_distance_target_category) {
        DistanceTargetCategory.create(test_all)
    }

   
    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {distance: "70m", target_id: 1, archer_category_id: 1, archer_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {distance: "30m", target_id: 1, archer_category_id: 1, archer_id: 1}
    }

    # every attr blank
    let(:blank) {
        {distance: "", target_id: "", archer_category_id: "", archer_id: ""}
    }

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            # load all AssocModels that must be in DB for tests to work
            valid_archer
            valid_category
            valid_target
        end

        describe "valid when " do
            it "given all required and unrequired attributes (all attrs are required)" do
                expect(DistanceTargetCategory.all.count).to eq(0)

                expect(test_distance_target_category).to be_valid
                expect(DistanceTargetCategory.all.count).to eq(1)
                expect(test_distance_target_category.distance).to eq(test_all[:distance])
                expect(test_distance_target_category.target_id).to eq(test_all[:target_id])
                expect(test_distance_target_category.archer_category_id).to eq(test_all[:archer_category_id])
                expect(test_distance_target_category.archer_id).to eq(test_all[:archer_id])
            end

            it "updating all attributes" do
                test_distance_target_category.update(update)
                
                expect(test_distance_target_category).to be_valid
                expect(test_distance_target_category.distance).to eq(update[:distance])
                expect(test_distance_target_category.target_id).to eq(update[:target_id])
                expect(test_distance_target_category.archer_category_id).to eq(update[:archer_category_id])
                expect(test_distance_target_category.archer_id).to eq(update[:archer_id])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                distance_target_category = DistanceTargetCategory.create(blank)

                expect(distance_target_category).to be_invalid
                expect(DistanceTargetCategory.all.count).to eq(0)

                expect(distance_target_category.errors.messages[:distance]).to include(default_missing_message)
                expect(distance_target_category.errors.messages[:target_id]).to include(default_missing_message)
                expect(distance_target_category.errors.messages[:archer_category_id]).to include(default_missing_message)
                expect(distance_target_category.errors.messages[:archer_id]).to include(default_missing_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load test object
            test_distance_target_category

            # load all AssocModels that must be in DB for tests to work
            valid_archer
            valid_category
            valid_target
        end

        it "belongs to a Target" do
            expect(test_distance_target_category.target).to eq(valid_target)
        end
    
        it "belongs to an ArcherCategory" do
            expect(test_distance_target_category.archer_category).to eq(valid_category)
        end

        it "belongs to an Archer" do
            expect(test_distance_target_category.archer).to eq(valid_archer)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_distance_target_category).to be_valid
        end
    end
end
