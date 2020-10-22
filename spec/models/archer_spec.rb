require 'rails_helper'

RSpec.describe Archer, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {
            username: "testuser", 
            email: "testuser@example.com", 
            password: "test", 
            first_name: "Test", 
            last_name: "Tuser", 
            birthdate: "1980-07-01", 
            gender: "Male", 
            home_city: "Denver", 
            home_state: "CO", 
            home_country: "USA", 
            default_age_class: "Senior", 
            default_division: "Recurve"
        }
    }
        
    let(:test_archer) {
        Archer.create(test_all)
    }

    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing
    let(:valid_category_junior) {
        ArcherCategory.create(
            cat_code: "WA-RJW", 
            gov_body: "World Archery", 
            cat_division: "Recurve", 
            cat_age_class: "Junior", 
            min_age: 18, 
            max_age: 20, 
            open_to_younger: true, 
            open_to_older: false, 
            cat_gender: "Female"
        )
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required atts and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {username: "testuser", email: "testuser@example.com", password: "test", first_name: "Test", last_name: "Tuser", birthdate: "1980-07-01", gender: "Male", default_division: "Recurve"}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {username: "testuser", email: "testuser@example.com", password: "test", first_name: "Test", last_name: "Tuser", birthdate: "1980-07-01", gender: "Male", home_city: "Denver", home_state: "CO", home_country: "USA", default_age_class: "Senior", default_division: "Recurve"}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {username: "updateuser", email: "update-user@example.com", password: "test", first_name: "Jane", last_name: "Doe", birthdate: "2001-10-01", gender: "Female", home_city: "Chicago", home_state: "IL", home_country: "CAN", default_age_class: "", default_division: "Compound"}
    }

    # every attr blank
    let(:blank) {
        {username: "", email: "", password: "", first_name: "", last_name: "", birthdate: "", gender: "", home_city: "", home_state: "", home_country: "", default_age_class: "", default_division: ""}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_age_class) {"Senior"}
    let(:assigned_age_class_update) {"Junior"}    
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_username_message) {"You must provide a username."}
    let(:missing_email_message) {"You must provide your email."}
    let(:missing_first_name_message) {"You must provide your first name."}
    let(:missing_last_name_message) {"You must provide your last name."}
    let(:missing_birthdate_message) {"You must provide your birthdate."}
    let(:missing_gender_message) {"You must provide your gender."}
    let(:missing_division_message) {"You must enter your primary shooting style."}

    let(:duplicate_username_message) {"That username is already taken."}
    let(:duplicate_email_message) {"That email is already taken."}
    
    let(:inclusion_gender_message) {"You can only choose male or female."}

    let(:format_username_message) {"Username can only use letters and numbers without spaces."}
    let(:format_email_message) {"Email doesn't look valid. Please use another."}
    
    
    
    

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            valid_category
            valid_category_junior
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Archer.all.count).to eq(0)

                expect(test_archer).to be_valid
                expect(Archer.all.count).to eq(1)
                expect(test_archer.authenticate(test_all[:password])).to eq(test_archer)

                expect(test_archer.username).to eq(test_all[:username])
                expect(test_archer.email).to eq(test_all[:email])
                expect(test_archer.first_name).to eq(test_all[:first_name])
                expect(test_archer.last_name).to eq(test_all[:last_name])
                expect(test_archer.birthdate).to eq(test_all[:birthdate].to_date)
                expect(test_archer.gender).to eq(test_all[:gender])
                expect(test_archer.home_city).to eq(test_all[:home_city])
                expect(test_archer.home_state).to eq(test_all[:home_state])
                expect(test_archer.home_country).to eq(test_all[:home_country])
                expect(test_archer.default_age_class).to eq(test_all[:default_age_class])
                expect(test_archer.default_division).to eq(test_all[:default_division])
            end
            
            it "given only required attributes" do
                expect(Archer.all.count).to eq(0)
                archer = Archer.create(test_req)

                expect(archer).to be_valid
                expect(Archer.all.count).to eq(1)
                expect(archer.authenticate(test_req[:password])).to eq(archer)

                expect(archer.username).to eq(test_req[:username])
                expect(archer.email).to eq(test_req[:email])
                expect(archer.first_name).to eq(test_req[:first_name])
                expect(archer.last_name).to eq(test_req[:last_name])
                expect(archer.birthdate).to eq(test_req[:birthdate].to_date)
                expect(archer.gender).to eq(test_req[:gender])
                expect(archer.default_division).to eq(test_req[:default_division])

                # not req input tests (default_age_class auto-asigned from missing)
                expect(archer.home_city).to be_nil
                expect(archer.home_state).to be_nil
                expect(archer.home_country).to be_nil
                expect(archer.default_age_class).to eq(assigned_age_class)
            end

            it "updating all attributes" do
                test_archer.update(update)
                
                expect(test_archer).to be_valid
                expect(test_archer.authenticate(update[:password])).to eq(test_archer)
                
                # req input tests (should have value in test_req)
                expect(test_archer.username).to eq(update[:username])
                expect(test_archer.email).to eq(update[:email])
                expect(test_archer.first_name).to eq(update[:first_name])
                expect(test_archer.last_name).to eq(update[:last_name])
                expect(test_archer.birthdate).to eq(update[:birthdate].to_date)
                expect(test_archer.gender).to eq(update[:gender])
                expect(test_archer.home_city).to eq(update[:home_city])
                expect(test_archer.home_state).to eq(update[:home_state])
                expect(test_archer.home_country).to eq(update[:home_country])
                expect(test_archer.default_division).to eq(update[:default_division])
                
                # not req input tests (<list attrs> auto-asigned from blank)
                expect(test_archer.default_age_class).to eq(assigned_age_class_update)
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                archer = Archer.create(blank)

                expect(archer).to be_invalid
                expect(Archer.all.count).to eq(0)

                expect(archer.errors.messages[:username]).to include(missing_username_message)
                expect(archer.errors.messages[:email]).to include(missing_email_message)
                expect(archer.errors.messages[:password]).to include(default_missing_message)
                expect(archer.errors.messages[:first_name]).to include(missing_first_name_message)
                expect(archer.errors.messages[:last_name]).to include(missing_last_name_message)
                expect(archer.errors.messages[:birthdate]).to include(missing_birthdate_message)
                expect(archer.errors.messages[:gender]).to include(missing_gender_message)
                expect(archer.errors.messages[:default_age_class]).to include(default_missing_message)
                expect(archer.errors.messages[:default_division]).to include(missing_division_message)
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_archer
                expect(Archer.all.count).to eq(1)
                archer = Archer.create(duplicate)

                expect(archer).to be_invalid
                expect(Archer.all.count).to eq(1)
                
                expect(archer.errors.messages[:username]).to include(duplicate_username_message)
                expect(archer.errors.messages[:email]).to include(duplicate_email_message)
            end

            it "attributes are outside allowable inputs" do
                duplicate[:gender] = "bad data"
                duplicate[:default_age_class] = "bad data"
                duplicate[:default_division] = "bad data"
                archer = Archer.create(duplicate)

                expect(archer).to be_invalid
                expect(Archer.all.count).to eq(0)
                expect(archer.errors.messages[:gender]).to include(inclusion_gender_message)
                expect(archer.errors.messages[:default_age_class]).to include(default_inclusion_message)
                expect(archer.errors.messages[:default_division]).to include(default_inclusion_message)
            end

            # this is the complex version - use for multiple/specific conditions on same attr (inclusion or format)
            
            it "username is the wrong format" do
                bad_scenarios = ["bad user", "ba$d%u$er", "bad.user!"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:username] = test_value
                    archer = Archer.create(duplicate)
                    expect(archer).to be_invalid
                    expect(Archer.all.count).to eq(0)
                    expect(archer.errors.messages[:username]).to include(format_username_message)
                end
            end
            
            it "email is the wrong format" do
                bad_scenarios = ["joe blow@example.com", "joe_blowexample.com", "joe_blow@examplecom", "joe_blow@example.", "joe_blow@example.c", "joe_blow@example.comm", "joe_blow@example.c2m", "@example.com", "joe_blow@.com"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:email] = test_value
                    archer = Archer.create(duplicate)
                    expect(archer).to be_invalid
                    expect(Archer.all.count).to eq(0)
                    expect(archer.errors.messages[:email]).to include(format_email_message)
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load test object
            
            # load all AssocModels that must be in DB for tests to work

        end

        it "has many ScoreSessions" do
            pending "need to add create associated models and add associations"
            expect(test_archer.score_sessions).to include(valid_score_session)
        end
    
        it "has many Rounds" do
            pending "need to add create associated models and add associations"
            expect(test_archer.rounds).to include(valid_round)
        end
    
        it "has many Sets" do
            pending "need to add create associated models and add associations"
            expect(test_archer.sets).to include(valid_set)
        end

        it "has many Ends" do
            pending "need to add create associated models and add associations"
            expect(test_archer.ends).to include(valid_end)
        end
    
        it "has many Shots" do
            pending "need to add create associated models and add associations"
            expect(test_archer.shots).to include(valid_shot)
        end
    
        it "has many ArcherCategories" do
            pending "need to add create associated models and add associations"
            expect(test_archer.archer_categories).to include(valid_category)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        before(:each) do
            valid_category
            valid_category_junior
        end

        it "can return the archer's first and last names with correct capitalization" do
            duplicate[:first_name] = "some"
            duplicate[:last_name] = "tester"
            archer = Archer.create(duplicate)
            
            expect(archer.first_name).to eq("Some")
            expect(archer.last_name).to eq("Tester")
        end
    
        it "can return the archer's full name with correct capitalization" do
            duplicate[:first_name] = "some"
            duplicate[:last_name] = "tester"
            archer = Archer.create(duplicate)

            expect(archer.full_name).to eq("Some Tester")
        end
    
        it "can return the archer's actual age" do
            allow(Date).to receive(:today).and_return Date.new(2020,10,1)
            expect(test_archer.age).to eq(40)
        
            allow(Date).to receive(:today).and_return Date.new(2020,1,1)
            expect(test_archer.age).to eq(39)
        end
        
        it "can return all the categories the archer is elgibile for" do
            expect(test_archer.eligbile_categories).to include(valid_category.name)
        end
    
        it "can return all the age classes the archer is elgibile for" do
            expect(test_archer.eligbile_age_classes).to include(valid_category.cat_age_class)
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_archer).to be_invalid
        end
    end
end
