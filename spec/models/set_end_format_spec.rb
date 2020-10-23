require 'rails_helper'

RSpec.describe SetEndFormat, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures

    let(:test_all) {
        {name: "Set/Distance2", num_ends: 6, shots_per_end: 6, user_edit: false, round_format_id: 1}
    }

    let(:test_set_end_format) {
        SetEndFormat.create(test_all)
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
        {num_ends: 6, shots_per_end: 6, round_format_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "Set/Distance2", num_ends: 6, shots_per_end: 6, user_edit: false, round_format_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "", num_ends: 12, shots_per_end: 3, round_format_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", num_ends: "", shots_per_end: "", user_edit: "", round_format_id: ""}
    }
    
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name) {"Set/Distance2"}
    let(:default_user_edit) {true}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:number_all_message) {"You must enter a number greater than 0."}
    
    
    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(SetEndFormat.all.count).to eq(0)

                expect(test_set_end_format).to be_valid
                expect(SetEndFormat.all.count).to eq(1)
                
                expect(test_set_end_format.name).to eq(test_all[:name])
                expect(test_set_end_format.num_ends).to eq(test_all[:num_ends])
                expect(test_set_end_format.shots_per_end).to eq(test_all[:shots_per_end])
                expect(test_set_end_format.user_edit).to eq(test_all[:user_edit])
            end

            it "given only required attributes" do
                expect(SetEndFormat.all.count).to eq(0)
                set_end_format = SetEndFormat.create(test_req)

                expect(set_end_format).to be_valid
                expect(SetEndFormat.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(set_end_format.num_ends).to eq(test_req[:num_ends])
                expect(set_end_format.shots_per_end).to eq(test_req[:shots_per_end])
                
                # not req input tests (name and user_edit auto-asigned from missing)
                expect(set_end_format.name).to eq(assigned_name)
                expect(set_end_format.user_edit).to eq(default_user_edit)
            end

            it "updating all attributes" do
                test_set_end_format.update(update)

                expect(test_set_end_format).to be_valid
                
                # req input tests (should have value in update)
                expect(test_set_end_format.num_ends).to eq(update[:num_ends])
                expect(test_set_end_format.shots_per_end).to eq(update[:shots_per_end])
                
                # not req input tests (name auto-asigned from blank, user_edit originally manually set and unchanged, so should be original)
                expect(test_set_end_format.name).to eq(assigned_name)
                expect(test_set_end_format.user_edit).to eq(test_all[:user_edit])
            end

            it "name is duplicated but for different RoundFormat" do
                pending "need to create associated models and add associations"

                # need two round_formats
                valid_round_format
                RoundFormat.create(name: "720 Round", num_sets: 2, user_edit: false)
                expect(RoundFormat.all.count).to eq(2)
                expect(SetEndFormat.all.count).to eq(0)

                # gives me 2 se_forms in valid_round_format
                valid_set_end_format
                test_set_end_format
                expect(SetEndFormat.all.count).to eq(2)
                
                # gives me 1 se_form in second_round_format
                SetEndFormat.create(name: "Set/Distance1", num_ends: 6, shots_per_end: 6, round_format_id: 2)
                expect(SetEndFormat.all.count).to eq(3)

                # test duped name from valid_round_format but in second_round_format
                set_end_format = SetEndFormat.create(duplicate)

                expect(set_end_format).to be_valid
                expect(SetEndFormat.all.count).to eq(4)

                expect(set_end_format.name).to eq(assigned_name)
                expect(test_set_end_format.num_ends).to eq(duplicate[:num_ends])
                expect(test_set_end_format.shots_per_end).to eq(duplicate[:shots_per_end])
                expect(test_set_end_format.user_edit).to eq(default_user_edit)
            end
        end
    
        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                set_end_format = SetEndFormat.create(blank)

                expect(set_end_format).to be_invalid
                expect(SetEndFormat.all.count).to eq(0)

                expect(set_end_format.errors.messages[:num_ends]).to include(number_all_message)
                expect(set_end_format.errors.messages[:shots_per_end]).to include(number_all_message)
            end
            
            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_set_end_format
                expect(SetEndFormat.all.count).to eq(1)
                set_end_format = SetEndFormat.create(duplicate)

                expect(set_end_format).to be_invalid
                expect(SetEndFormat.all.count).to eq(1)
                expect(set_end_format.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "attributes are outside allowable inputs" do
                duplicate[:num_ends] = "six"
                duplicate[:shots_per_end] = "six"
                set_end_format = SetEndFormat.create(duplicate)

                expect(set_end_format).to be_invalid
                expect(SetEndFormat.all.count).to eq(0)
                expect(set_end_format.errors.messages[:num_ends]).to include(number_all_message)
                expect(set_end_format.errors.messages[:shots_per_end]).to include(number_all_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load test object
            
            # load all AssocModels that must be in DB for tests to work
        end

        it "belongs to RoundFormat" do
            pending "need to create associated models and add associations"
            expect(test_set_end_format.round_format).to eq(valid_round_format)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_set_end_format).to be_invalid
        end
    end
end
