require 'rails_helper'

RSpec.describe RoundFormat, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "720 Round", num_sets: 2, user_edit: false}
    }
    
    let(:test_round_format) {
        RoundFormat.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {name: "720 Round", num_sets: 2}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "720 Round", num_sets: 2, user_edit: false}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "Double 720 Round", num_sets: 4}
    }

    # every attr blank
    let(:blank) {
        {name: "", num_sets: "", user_edit: ""}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:default_user_edit) {true}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a name."}
    
    let(:duplicate_name_message) {"That name is already taken."}
    
    let(:number_all_message) {"You must enter a number greater than 0."}


    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(RoundFormat.all.count).to eq(0)

                expect(test_round_format).to be_valid
                expect(RoundFormat.all.count).to eq(1)

                expect(test_round_format.name).to eq(test_all[:name])
                expect(test_round_format.num_sets).to eq(test_all[:num_sets])
                expect(test_round_format.user_edit).to eq(test_all[:user_edit])
            end
            
            it "given only required attributes" do
                expect(RoundFormat.all.count).to eq(0)
                round_format = RoundFormat.create(test_req)

                expect(round_format).to be_valid
                expect(RoundFormat.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(round_format.name).to eq(test_req[:name])
                expect(round_format.num_sets).to eq(test_req[:num_sets])

                # not req input tests (user_edit auto-asigned from missing)
                expect(round_format.user_edit).to eq(default_user_edit)
            end

            it "updating all attributes" do
                test_round_format.update(update)
                
                expect(test_round_format).to be_valid
                
                # req input tests (should have value in update)
                expect(test_round_format.name).to eq(update[:name])
                expect(test_round_format.num_sets).to eq(update[:num_sets])
                
                # not req input tests (user_edit originally manually set and unchanged, so should be original)
                expect(test_round_format.user_edit).to eq(test_all[:user_edit])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                round_format = RoundFormat.create(blank)

                expect(round_format).to be_invalid
                expect(RoundFormat.all.count).to eq(0)

                expect(round_format.errors.messages[:name]).to include(missing_name_message)
                expect(round_format.errors.messages[:num_sets]).to include(number_all_message)
            end

            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_round_format
                expect(RoundFormat.all.count).to eq(1)
                round_format = RoundFormat.create(duplicate)

                expect(round_format).to be_invalid
                expect(RoundFormat.all.count).to eq(1)
                expect(round_format.errors.messages[:name]).to include(duplicate_name_message)
            end

            it "attributes are outside allowable inputs" do
                duplicate[:num_sets] = "four"
                round_format = RoundFormat.create(duplicate)

                expect(round_format).to be_invalid
                expect(RoundFormat.all.count).to eq(0)
                expect(round_format.errors.messages[:num_sets]).to include(number_all_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load test object
            
            # load all AssocModels that must be in DB for tests to work
        end

        it "has many SetEndFormats" do
            test_round_format
            assoc_round_format = valid_round_format
            check_se_format_attrs = {num_ends: 6, shots_per_end: 6}

            # can find an associated object
            assoc_set_end_format = valid_set_end_format
            expect(test_round_format.set_end_formats).to include(assoc_set_end_format)


            # can create a new associated object via instance and get assoc object attributes
            check_set_end_format = test_round_format.set_end_formats.create(check_se_format_attrs)
            
            expect(test_round_format.set_end_formats).to include(check_set_end_format)
            expect(test_round_format.set_end_formats.last.name).to include(check_set_end_format.name)

            
            # can re-assign instance via the associated object
            assoc_set_end_format.round_format = assoc_round_format
            assoc_set_end_format.save

            expect(test_round_format.set_end_formats).not_to include(assoc_set_end_format)
            expect(assoc_round_format.set_end_formats).to include(assoc_set_end_format)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the round's name with correct capitalization" do
            duplicate[:name] = "1440 round"
            round_format = RoundFormat.create(duplicate)
            expect(round_format.name).to eq(duplicate[:name].titlecase)
        end
    end
end
