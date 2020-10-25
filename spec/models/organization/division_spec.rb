require 'rails_helper'

RSpec.describe Organization::Division, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "Compound"}
    }
        
    let(:test_division) {
        Organization::Division.create(test_all)
    }

    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing


    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    # let(:test_req) {
    #     {name: "Compound"}
    # }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "Compound"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "Barebow"}
    }

    # every attr blank
    let(:blank) {
        {name: ""}
    }
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a name."}
    
    let(:duplicate_name_message) {"That name is already taken."}


    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes (all are required)" do
                expect(Organization::Division.all.count).to eq(0)

                expect(test_division).to be_valid
                expect(Organization::Division.all.count).to eq(1)

                expect(test_division.name).to eq(test_all[:name])
            end

            it "updating all attributes" do
                test_division.update(update)
                
                expect(test_division).to be_valid
                
                # req input tests (should have value in update)
                expect(test_division.name).to eq(update[:name])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                division = Organization::Division.create(blank)

                expect(division).to be_invalid
                expect(Organization::Division.all.count).to eq(0)

                expect(division.errors.messages[:name]).to include(missing_name_message)
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_division
                expect(Organization::Division.all.count).to eq(1)
                division = Organization::Division.create(duplicate)

                expect(division).to be_invalid
                expect(Organization::Division.all.count).to eq(1)
                expect(division.errors.messages[:name]).to include(duplicate_name_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load the main test instance (for has many_many only)
            test_division
        end 

        describe "has many GovBodies and can" do
            it "find an associated object" do
                assoc_gov_body = valid_gov_body
                expect(test_division.gov_bodies).to include(assoc_gov_body)
            end

            it "create a new associated object via instance and get associated object attributes" do
                check_gov_body_attrs = {name: "Longbow"}
                check_gov_body = test_division.gov_bodies.create(check_gov_body_attrs)
                
                expect(test_division.gov_bodies).to include(check_gov_body)
                expect(test_division.gov_bodies.last.name).to eq(check_gov_body.name)
            end
            
            it "re-assign instance via the associated object" do
                assoc_division = valid_division
                assoc_gov_body = valid_gov_body
                
                assoc_gov_body.division = assoc_division
                assoc_gov_body.save

                expect(test_division.gov_bodies).not_to include(assoc_gov_body)
                expect(assoc_division.gov_bodies).to include(assoc_gov_body)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the age class's name with correct capitalization" do
            duplicate[:name] = "longer bow"
            division = Organization::Division.create(duplicate)
            expect(division.name).to eq(duplicate[:name].titlecase)
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_division).to be_invalid
        end
    end
end
