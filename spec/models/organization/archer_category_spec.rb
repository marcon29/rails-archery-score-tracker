require 'rails_helper'

RSpec.describe Organization::ArcherCategory, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {cat_code: "USA-RM", gov_body_id: 1, discipline_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    }
        
    let(:test_archer_category) {
        Organization::ArcherCategory.create(test_all)
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
    #     {cat_code: "WA-RJM", gov_body_id: 1, discipline_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    # }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {cat_code: "USA-RM", gov_body_id: 1, discipline_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {cat_code: "USA-RJM", gov_body_id: 1, discipline_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    }

    # every attr blank
    let(:blank) {
        {cat_code: "", gov_body_id: "", discipline_id: "", division_id: "", age_class_id: "", gender_id: ""}
    }
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_cat_code_message) {"You must provide a category code."}
    
    let(:duplicate_cat_code_message) {"That category code is already used."}

    # let(:inclusion_attr_message) {}
    # let(:number_attr_message) {}
    # let(:format_attr_message) {}
    

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            valid_gov_body
            valid_discipline
            valid_division
            valid_age_class
            valid_gender
        end

        describe "valid when " do
            it "given all required and unrequired attributes (all are required)" do
                expect(Organization::ArcherCategory.all.count).to eq(0)

                expect(test_archer_category).to be_valid
                expect(Organization::ArcherCategory.all.count).to eq(1)

                expect(test_archer_category.cat_code).to eq(test_all[:cat_code])
            end

            it "updating all attributes" do
                test_archer_category.update(update)
                
                expect(test_archer_category).to be_valid
                
                # req input tests (should have value in update)
                expect(test_archer_category.cat_code).to eq(update[:cat_code])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                archer_category = Organization::ArcherCategory.create(blank)

                expect(archer_category).to be_invalid
                expect(Organization::ArcherCategory.all.count).to eq(0)

                expect(archer_category.errors.messages[:cat_code]).to include(missing_cat_code_message)
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_archer_category
                expect(Organization::ArcherCategory.all.count).to eq(1)
                archer_category = Organization::ArcherCategory.create(duplicate)

                expect(archer_category).to be_invalid
                expect(Organization::ArcherCategory.all.count).to eq(1)
                expect(archer_category.errors.messages[:cat_code]).to include(duplicate_cat_code_message)
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        describe "belongs to GovBody and can" do
            it "find an associated object" do
                assoc_gov_body = valid_gov_body
                expect(test_archer_category.gov_body).to eq(assoc_gov_body)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_gov_body = valid_gov_body
                update[:gov_body_id] = ""
                check_archer_category = assoc_gov_body.archer_categories.create(update)
                
                expect(check_archer_category.gov_body).to eq(assoc_gov_body)
                expect(check_archer_category.gov_body.name).to include(assoc_gov_body.name)
            end
        end

        describe "belongs to Disciplline and can" do
            it "find an associated object" do
                assoc_discipline = valid_discipline
                expect(test_archer_category.discipline).to eq(assoc_discipline)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_discipline = valid_discipline
                update[:discipline_id] = ""
                check_archer_category = assoc_discipline.archer_categories.create(update)
                
                expect(check_archer_category.discipline).to eq(assoc_discipline)
                expect(check_archer_category.discipline.name).to include(assoc_discipline.name)
            end
        end

        describe "belongs to Division and can" do
            it "find an associated object" do
                assoc_division = valid_division
                expect(test_archer_category.division).to eq(assoc_division)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_division = valid_division
                update[:division_id] = ""
                check_archer_category = assoc_division.archer_categories.create(update)
                
                expect(check_archer_category.division).to eq(assoc_division)
                expect(check_archer_category.division.name).to include(assoc_division.name)
            end
        end

        describe "belongs to AgeClass and can" do
            it "find an associated object" do
                assoc_age_class = valid_age_class
                expect(test_archer_category.age_class).to eq(assoc_age_class)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_age_class = valid_age_class
                update[:age_class_id] = ""
                check_archer_category = assoc_age_class.archer_categories.create(update)
                
                expect(check_archer_category.age_class).to eq(assoc_age_class)
                expect(check_archer_category.age_class.name).to include(assoc_age_class.name)
            end
        end

        describe "belongs to Gender and can" do
            it "find an associated object" do
                assoc_gender = valid_gender
                expect(test_archer_category.gender).to eq(assoc_gender)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_gender = valid_gender
                update[:gender_id] = ""
                check_archer_category = assoc_gender.archer_categories.create(update)
                
                expect(check_archer_category.gender).to eq(assoc_gender)
                expect(check_archer_category.gender.name).to include(assoc_gender.name)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            valid_gov_body
            valid_discipline
            valid_division
            valid_age_class
            valid_gender
        end

        it "has a user-friendly display name" do
            expect(test_archer_category.name).to eq("Recurve-Senior-Men")
        end

        it "can return the category code correctly formatted" do
            duplicate[:cat_code] = "w a- cj w"
            archer_category = Organization::ArcherCategory.create(duplicate)
            expect(archer_category.cat_code).to eq("WA-CJW")
        end


        it "helpers TBD" do
            pending "add as needed"
            expect(test_archer_category).to be_invalid
        end
    end
end
