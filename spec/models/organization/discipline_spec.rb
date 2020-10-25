require 'rails_helper'

RSpec.describe Organization::Discipline, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "Indoor"}
    }
        
    let(:test_discipline) {
        Organization::Discipline.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "Indoor"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "Field"}
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
                expect(Organization::Discipline.all.count).to eq(0)

                expect(test_discipline).to be_valid
                expect(Organization::Discipline.all.count).to eq(1)

                expect(test_discipline.name).to eq(test_all[:name])
            end

            it "updating all attributes" do
                test_discipline.update(update)
                
                expect(test_discipline).to be_valid
                
                # req input tests (should have value in update)
                expect(test_discipline.name).to eq(update[:name])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                discipline = Organization::Discipline.create(blank)

                expect(discipline).to be_invalid
                expect(Organization::Discipline.all.count).to eq(0)

                expect(discipline.errors.messages[:name]).to include(missing_name_message)
            end

            it "unique attributes are duplicated" do
                test_discipline
                expect(Organization::Discipline.all.count).to eq(1)
                discipline = Organization::Discipline.create(duplicate)

                expect(discipline).to be_invalid
                expect(Organization::Discipline.all.count).to eq(1)
                expect(discipline.errors.messages[:name]).to include(duplicate_name_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            test_discipline

            @assoc_gov_body = valid_gov_body
            @assoc_division = valid_division
            @assoc_age_class = valid_age_class
            @assoc_gender = valid_gender
            @valid_category = valid_category
        end 

        describe "has many GovBodies and can" do
            it "find an associated object" do
                expect(test_discipline.gov_bodies).to include(@assoc_gov_body)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the age class's name with correct capitalization" do
            duplicate[:name] = "flight"
            discipline = Organization::Discipline.create(duplicate)
            expect(discipline.name).to eq(duplicate[:name].titlecase)
        end
    end
end
