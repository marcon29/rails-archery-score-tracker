require 'rails_helper'

RSpec.describe Organization::AgeClass, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false}
    }
        
    let(:test_age_class) {
        Organization::AgeClass.create(test_all)
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
        {name: "Junior", open_to_younger: true, open_to_older: false}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "Master", min_age: "", max_age: "", open_to_younger: false, open_to_older: true}
    }

    # every attr blank
    let(:blank) {
        {name: "", min_age: "", max_age: "", open_to_younger: "", open_to_older: ""}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_min_age) {0}
    let(:assigned_max_age) {1000}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a name."}
    let(:invalid_age_message) {"You must enter a number greater than 0."}
    let(:missing_open_message) {"You must select if an open class."}
    
    let(:duplicate_name_message) {"That name is already taken."}


    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes (all are required)" do
                expect(Organization::AgeClass.all.count).to eq(0)

                expect(test_age_class).to be_valid
                expect(Organization::AgeClass.all.count).to eq(1)

                expect(test_age_class.name).to eq(test_all[:name])
                expect(test_age_class.min_age).to eq(test_all[:min_age])
                expect(test_age_class.max_age).to eq(test_all[:max_age])
                expect(test_age_class.open_to_younger).to eq(test_all[:open_to_younger])
                expect(test_age_class.open_to_older).to eq(test_all[:open_to_older])
            end
            
            it "it auto-assigns min and max ages if not given" do
                expect(Organization::AgeClass.all.count).to eq(0)
                age_class = Organization::AgeClass.create(test_req)

                expect(age_class).to be_valid
                expect(Organization::AgeClass.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(age_class.name).to eq(test_req[:name])
                expect(age_class.open_to_younger).to eq(test_req[:open_to_younger])
                expect(age_class.open_to_older).to eq(test_req[:open_to_older])

                # not req input tests (min_age and max_age auto-asigned from missing)
                expect(age_class.min_age).to eq(assigned_min_age)
                expect(age_class.max_age).to eq(assigned_max_age)
            end

            it "updating all attributes" do
                test_age_class.update(update)
                
                expect(test_age_class).to be_valid
                
                # req input tests (should have value in update)
                expect(test_age_class.name).to eq(update[:name])
                expect(test_age_class.open_to_younger).to eq(update[:open_to_younger])
                expect(test_age_class.open_to_older).to eq(update[:open_to_older])
                
                # not req input tests (min_age and max_age auto-asigned from blank)
                expect(test_age_class.min_age).to eq(assigned_min_age)
                expect(test_age_class.max_age).to eq(assigned_max_age)
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                age_class = Organization::AgeClass.create(blank)

                expect(age_class).to be_invalid
                expect(Organization::AgeClass.all.count).to eq(0)

                expect(age_class.errors.messages[:name]).to include(missing_name_message)
                expect(age_class.errors.messages[:min_age]).to include(invalid_age_message)
                expect(age_class.errors.messages[:max_age]).to include(invalid_age_message)
                expect(age_class.errors.messages[:open_to_younger]).to include(missing_open_message)
                expect(age_class.errors.messages[:open_to_older]).to include(missing_open_message)
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_age_class
                expect(Organization::AgeClass.all.count).to eq(1)
                age_class = Organization::AgeClass.create(duplicate)

                expect(age_class).to be_invalid
                expect(Organization::AgeClass.all.count).to eq(1)
                expect(age_class.errors.messages[:name]).to include(duplicate_name_message)
            end
            
            it "min_age is outside allowable inputs" do
                bad_scenarios = [0, -1, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:min_age] = test_value
                    age_class = Organization::AgeClass.create(duplicate)
                    expect(age_class).to be_invalid
                    expect(Organization::AgeClass.all.count).to eq(0)
                    expect(age_class.errors.messages[:min_age]).to include(invalid_age_message)
                end
            end

            it "max_age is outside allowable inputs" do
                bad_scenarios = [0, -1, "one"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:max_age] = test_value
                    age_class = Organization::AgeClass.create(duplicate)
                    expect(age_class).to be_invalid
                    expect(Organization::AgeClass.all.count).to eq(0)
                    expect(age_class.errors.messages[:max_age]).to include(invalid_age_message)
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load the main test instance (for has many_many only)
            test_age_class
        end 

        describe "has many GovBodies and can" do
            it "find an associated object" do
                assoc_gov_body = valid_gov_body
                expect(test_age_class.gov_bodies).to include(assoc_gov_body)
            end

            it "create a new associated object via instance and get associated object attributes" do
                check_gov_body_attrs = {name: "Bear Creek Archers", org_type: "Local", geo_area: "the range"}
                check_gov_body = test_age_class.gov_bodies.create(check_gov_body_attrs)
                
                expect(test_age_class.gov_bodies).to include(check_gov_body)
                expect(test_age_class.gov_bodies.last.name).to eq(check_gov_body.name)
            end
            
            it "re-assign instance via the associated object" do
                assoc_age_class = valid_age_class
                assoc_gov_body = valid_gov_body
                
                assoc_gov_body.age_class = assoc_age_class
                assoc_gov_body.save

                expect(test_age_class.gov_bodies).not_to include(assoc_gov_body)
                expect(assoc_age_class.gov_bodies).to include(assoc_gov_body)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the age class's name with correct capitalization" do
            duplicate[:name] = "bowman"
            age_class = Organization::AgeClass.create(duplicate)
            expect(age_class.name).to eq(duplicate[:name].titlecase)
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_age_class).to be_invalid
        end
    end
end
