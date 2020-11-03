require 'rails_helper'

RSpec.describe Organization::ArcherCategory, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {cat_code: "USA-RM", gov_body_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
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
    #     {cat_code: "WA-RJM", gov_body_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    # }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {cat_code: "USA-RM", gov_body_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {cat_code: "USA-RJM", gov_body_id: 1, division_id: 1, age_class_id: 1, gender_id: 1}
    }

    # every attr blank
    let(:blank) {
        {cat_code: "", gov_body_id: "", division_id: "", age_class_id: "", gender_id: ""}
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

        describe "has many DistanceTargetCategories and" do
            it "can find an associated object" do
                expect(valid_category.distance_target_categories).to include(valid_dist_targ_cat)
            end
        end

        describe "has many Rounds and" do
            it "can find an associated object" do
                expect(valid_category.rounds).to include(valid_round)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            valid_gov_body
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

        it "can find all eligible ArcherCategories by age and Gender" do
            expect(Organization::ArcherCategory.all.count).to eq(0)
            rjm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RJM", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class_alt, gender: valid_gender)
            rsm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RM", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class, gender: valid_gender)
            rjw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RJW", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class_alt, gender: valid_gender_alt)
            rsw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RW", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class, gender: valid_gender_alt)
            expect(Organization::ArcherCategory.all.count).to eq(4)
            expect(Organization::Division.all.count).to eq(1)
            expect(Organization::AgeClass.all.count).to eq(2)
            expect(Organization::Gender.all.count).to eq(2)
            junior_min = 18
            junior_max = 20
            senior_min = 21
            senior_max = 49

            male_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: junior_min, gender: valid_gender)
            female_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: junior_min, gender: valid_gender_alt)
            expect(male_cats).to include(rjm)
            expect(male_cats).to include(rsm)
            expect(female_cats).to include(rjw)
            expect(female_cats).to include(rsw)

            male_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: junior_max, gender: valid_gender)
            female_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: junior_max, gender: valid_gender_alt)
            expect(male_cats).to include(rjm)
            expect(male_cats).to include(rsm)
            expect(female_cats).to include(rjw)
            expect(female_cats).to include(rsw)

            male_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: senior_min, gender: valid_gender)
            female_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: senior_min, gender: valid_gender_alt)
            expect(male_cats).to_not include(rjm)
            expect(male_cats).to include(rsm)
            expect(female_cats).to_not include(rjw)
            expect(female_cats).to include(rsw)

            male_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: senior_max, gender: valid_gender)
            female_cats = Organization::ArcherCategory.find_eligible_categories_by_age_gender(age: senior_max, gender: valid_gender_alt)
            expect(male_cats).to_not include(rjm)
            expect(male_cats).to include(rsm)
            expect(female_cats).to_not include(rjw)
            expect(female_cats).to include(rsw)
        end

        it "can find all ArcherCategories with same Division, AgeClass, and Gender" do
            expect(Organization::ArcherCategory.all.count).to eq(0)
            rjm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RJM", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class_alt, gender: valid_gender)
            rsm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RM", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class, gender: valid_gender)
            rjw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RW", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class_alt, gender: valid_gender_alt)
            rsw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RJW", gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class, gender: valid_gender_alt)

            cjm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CJM", gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class_alt, gender: valid_gender)
            csm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CM", gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class, gender: valid_gender)
            cjw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CW", gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class_alt, gender: valid_gender_alt)
            csw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CJW", gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class, gender: valid_gender_alt)
            expect(Organization::ArcherCategory.all.count).to eq(8)
            expect(Organization::Division.all.count).to eq(2)
            expect(Organization::AgeClass.all.count).to eq(2)
            expect(Organization::Gender.all.count).to eq(2)

            r_jr_male = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class_alt, gender: valid_gender)
            r_sr_male = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class, gender: valid_gender)
            r_jr_female = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class_alt, gender: valid_gender_alt)
            r_sr_female = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division, age_class: valid_age_class, gender: valid_gender_alt)
            expect(r_jr_male).to eq(rjm)
            expect(r_sr_male).to eq(rsm)
            expect(r_jr_female).to eq(rjw)
            expect(r_sr_female).to eq(rsw)

            c_jr_male = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class_alt, gender: valid_gender)
            c_sr_male = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class, gender: valid_gender)
            c_jr_female = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class_alt, gender: valid_gender_alt)
            c_sr_female = Organization::ArcherCategory.find_category(gov_body: valid_gov_body, division: valid_division_alt, age_class: valid_age_class, gender: valid_gender_alt)
            expect(c_jr_male).to eq(cjm)
            expect(c_sr_male).to eq(csm)
            expect(c_jr_female).to eq(cjw)
            expect(c_sr_female).to eq(csw)
        end


        it "helpers TBD" do
            pending "add as needed"
            expect(test_archer_category).to be_invalid
        end
    end
end
