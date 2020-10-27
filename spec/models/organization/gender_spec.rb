require 'rails_helper'

RSpec.describe Organization::Gender, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "Female"}
    }
        
    let(:test_gender) {
        Organization::Gender.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "Female"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "Trans"}
    }

    # every attr blank
    let(:blank) {
        {name: ""}
    }
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a gender."}
    let(:duplicate_name_message) {"That gender is already used."}


    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes (all are required)" do
                expect(Organization::Gender.all.count).to eq(0)

                expect(test_gender).to be_valid
                expect(Organization::Gender.all.count).to eq(1)

                expect(test_gender.name).to eq(test_all[:name])
            end

            it "updating all attributes" do
                test_gender.update(update)
                
                expect(test_gender).to be_valid
                
                # req input tests (should have value in update)
                expect(test_gender.name).to eq(update[:name])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                gender = Organization::Gender.create(blank)

                expect(gender).to be_invalid
                expect(Organization::Gender.all.count).to eq(0)

                expect(gender.errors.messages[:name]).to include(missing_name_message)
            end

            it "unique attributes are duplicated" do
                test_gender
                expect(Organization::Gender.all.count).to eq(1)
                gender = Organization::Gender.create(duplicate)

                expect(gender).to be_invalid
                expect(Organization::Gender.all.count).to eq(1)
                expect(gender.errors.messages[:name]).to include(duplicate_name_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            @gender = Organization::Gender.create(duplicate)
            archer_category = Organization::ArcherCategory.create(
                cat_code: "check", 
                gov_body: valid_gov_body_alt, 
                discipline: valid_discipline_alt, 
                division: valid_division_alt, 
                age_class: valid_age_class_alt, 
                gender: @gender
            )
        end 

        describe "has many GovBodies and can" do
            it "find an associated object" do
                expect(@gender.gov_bodies).to include(valid_gov_body_alt)
                expect(valid_gov_body_alt.genders).to include(@gender)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the age class's name with correct capitalization" do
            duplicate[:name] = "male"
            gender = Organization::Gender.create(duplicate)
            expect(gender.name).to eq(duplicate[:name].titlecase)
        end
    end
end
