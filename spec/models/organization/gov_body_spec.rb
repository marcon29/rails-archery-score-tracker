require 'rails_helper'

RSpec.describe Organization::GovBody, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "USA Archery", org_type: "National", geo_area: "USA"}
    }

    let(:test_gov_body) {
        Organization::GovBody.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {name: "USA Archery", org_type: "National"}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "USA Archery", org_type: "National", geo_area: "USA"}
    }
    
    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "CSAA", org_type: "State/Province", geo_area: "CO"}
    }

    # every attr blank
    let(:blank) {
        {name: "", org_type: "", geo_area: ""}
    }
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a name."}
    let(:missing_org_type_message) {"You must choose an organization type."}
    let(:duplicate_name_message) {"That name is already taken."}
    
    
    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Organization::GovBody.all.count).to eq(0)

                expect(test_gov_body).to be_valid
                expect(Organization::GovBody.all.count).to eq(1)

                expect(test_gov_body.name).to eq(test_all[:name])
                expect(test_gov_body.org_type).to eq(test_all[:org_type])
                expect(test_gov_body.geo_area).to eq(test_all[:geo_area])
            end
            
            it "given only required attributes" do
                expect(Organization::GovBody.all.count).to eq(0)
                gov_body = Organization::GovBody.create(test_req)

                expect(gov_body).to be_valid
                expect(Organization::GovBody.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(gov_body.name).to eq(test_req[:name])
                expect(gov_body.org_type).to eq(test_req[:org_type])

                # not req input tests (no attrs auto-asigned from missing)
                expect(gov_body.geo_area).to be_nil
            end

            it "updating all attributes" do
                test_gov_body.update(update)
                
                expect(test_gov_body).to be_valid
                
                # req input tests (should have value in update)
                expect(test_gov_body.name).to eq(update[:name])
                expect(test_gov_body.org_type).to eq(update[:org_type])
                expect(test_gov_body.geo_area).to eq(update[:geo_area])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                gov_body = Organization::GovBody.create(blank)

                expect(gov_body).to be_invalid
                expect(Organization::GovBody.all.count).to eq(0)

                expect(gov_body.errors.messages[:name]).to include(missing_name_message)
                expect(gov_body.errors.messages[:org_type]).to include(missing_org_type_message)
            end

            it "unique attributes are duplicated" do
                test_gov_body
                expect(Organization::GovBody.all.count).to eq(1)
                gov_body = Organization::GovBody.create(duplicate)

                expect(gov_body).to be_invalid
                expect(Organization::GovBody.all.count).to eq(1)
                expect(gov_body.errors.messages[:name]).to include(duplicate_name_message)
            end

            
            it "attributes are outside allowable inputs" do
                duplicate[:org_type] = "bad data"
                gov_body = Organization::GovBody.create(duplicate)

                expect(gov_body).to be_invalid
                expect(Organization::GovBody.all.count).to eq(0)
                expect(gov_body.errors.messages[:org_type]).to include(default_inclusion_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            @gov_body = Organization::GovBody.create(duplicate)
            archer_category = Organization::ArcherCategory.create(
                cat_code: "check", 
                gov_body: @gov_body, 
                discipline: valid_discipline_alt, 
                division: valid_division_alt, 
                age_class: valid_age_class_alt, 
                gender: valid_gender_alt
            )
        end

        describe "has many Disciplines" do
            it "find an associated object" do
                expect(@gov_body.disciplines).to include(valid_discipline_alt)
                expect(valid_discipline_alt.gov_bodies).to include(@gov_body)
            end
        end 

        describe "has many Divisions" do
            it "find an associated object" do
                expect(@gov_body.divisions).to include(valid_division_alt)
                expect(valid_division_alt.gov_bodies).to include(@gov_body)
            end
        end

        describe "has many AgeClasses" do
            it "find an associated object" do
                expect(@gov_body.age_classes).to include(valid_age_class_alt)
                expect(valid_age_class_alt.gov_bodies).to include(@gov_body)
            end
        end

        describe "has many Genders" do
            it "find an associated object" do
                expect(@gov_body.genders).to include(valid_gender_alt)
                expect(valid_gender_alt.gov_bodies).to include(@gov_body)
            end
        end
    end
end
