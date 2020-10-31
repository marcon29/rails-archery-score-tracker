require 'rails_helper'

RSpec.describe Organization::DistanceTargetCategory, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {set_end_format_id: 1, archer_category_id: 1, distance: "70m", target_id: 1}
        
    }
        
    let(:test_dtc) {
        Organization::DistanceTargetCategory.create(test_all)
    }

    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing
    let(:test_alt_targ) {
        {set_end_format_id: 1, archer_category_id: 1, distance: "70m", target_id: 1, alt_target_id: 2}
        
    }
        
    let(:test_dtc_alt_targ) {
        Organization::DistanceTargetCategory.create(test_alt_targ)
    }
   
    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {set_end_format_id: 1, archer_category_id: 1, distance: "70m", target_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {distance: "50m"}
    }

    # every attr blank
    let(:blank) {
        {set_end_format_id: 1, archer_category_id: 1, distance: "", target_id: 1}
    }

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            valid_set_end_format
            valid_category
            valid_target
        end

        describe "valid when " do
            it "given all required attributes (all attrs are required) for single target" do
                expect(Organization::DistanceTargetCategory.all.count).to eq(0)

                expect(test_dtc).to be_valid
                expect(Organization::DistanceTargetCategory.all.count).to eq(1)
                expect(test_dtc.distance).to eq(test_all[:distance])
                
                expect(test_dtc.set_end_format_id).to eq(test_all[:set_end_format_id])
                expect(test_dtc.archer_category_id).to eq(test_all[:archer_category_id])
                expect(test_dtc.target_id).to eq(test_all[:target_id])
                expect(test_dtc.alt_target_id).to be_nil
            end

            it "given all required attributes (all attrs are required) for alternate target" do
                valid_target_alt
                expect(Organization::DistanceTargetCategory.all.count).to eq(0)

                expect(test_dtc).to be_valid
                expect(Organization::DistanceTargetCategory.all.count).to eq(1)
                expect(test_dtc.distance).to eq(test_all[:distance])
                
                expect(test_dtc.set_end_format_id).to eq(test_all[:set_end_format_id])
                expect(test_dtc.archer_category_id).to eq(test_all[:archer_category_id])
                expect(test_dtc.target_id).to eq(test_all[:target_id])
                expect(test_dtc.alt_target_id).to be_nil
            end

            it "updating all attributes" do
                test_dtc.update(update)
                
                expect(test_dtc).to be_valid
                expect(test_dtc.distance).to eq(update[:distance])

                expect(test_dtc.set_end_format_id).to eq(test_all[:set_end_format_id])
                expect(test_dtc.archer_category_id).to eq(test_all[:archer_category_id])
                expect(test_dtc.target_id).to eq(test_all[:target_id])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                dtc = Organization::DistanceTargetCategory.create(blank)

                expect(dtc).to be_invalid
                expect(Organization::DistanceTargetCategory.all.count).to eq(0)

                expect(dtc.errors.messages[:distance]).to include(default_missing_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            valid_set_end_format
            valid_category
            valid_target
        end

        describe "belongs to a SetEndFormat and can" do
            it "find an associated object" do
                expect(test_dtc.set_end_format).to eq(valid_set_end_format)
            end
        end
        
        describe "belongs to a ArcherCategory and can" do
            it "find an associated object" do
                expect(test_dtc.archer_category).to eq(valid_category)
            end
        end

        describe "belongs to a Target and can" do
            it "find an associated object when only having primary target" do
                expect(test_dtc.target).to eq(valid_target)
            end

            it "find an associated object when having an alternate target" do
                valid_target_alt

                expect(test_dtc_alt_targ.target).to eq(valid_target)
                expect(test_dtc_alt_targ.alt_target).to eq(valid_target_alt)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            valid_set_end_format
            valid_category
            valid_target
        end

        it "can find the RoundFormat it belongs to via the SetEndFormat" do
            expect(test_dtc.round_format).to eq(valid_round_format)
        end

        it "knows if there is an alternate target" do
            valid_target_alt
            
            expect(test_dtc.has_alt_target?).to eq(false)
            expect(test_dtc_alt_targ.has_alt_target?).to eq(true)
        end

        it "can return all targets in an array" do
            valid_target_alt
            check = [valid_target]
            check_alt = [valid_target, valid_target_alt]
            
            expect(test_dtc.target_options).to eq(check)
            expect(test_dtc_alt_targ.target_options).to eq(check_alt)
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(dtc).to be_valid
        end
    end
end
