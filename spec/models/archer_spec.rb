require 'rails_helper'

RSpec.describe Archer, type: :model do
  # add all attr sets and instances of regular models needed for testing
  let(:valid_all) {
    {
      username: "testuser", 
      email: "testuser@example.com", 
      password: "test", 
      first_name: "Test", 
      last_name: "User", 
      birthdate: "1980-07-01", 
      gender: "Male", 
      home_city: "Denver", 
      home_state: "CO", 
      home_country: "USA", 
      default_age_class: "Senior"
    }
  }

  let(:test_archer) {
    Archer.create(valid_all)
  }

  # add all instances of AssocModel needed for testing associations (not persisted until called)
  # let(:assoc_score_session) {
  #   ScoreSession.create()
  # }

  # let(:assoc_round) {
  #   Round.create()
  # }

  let(:assoc_round_set) {
    RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
  }

  # let(:assoc_shot) {
  #   Shot.create()
  # }
  
  let(:assoc_category_senior) {
    ArcherCategory.create(
      cat_code: "WA-RM", 
      gov_body: "World Archery", 
      cat_division: "Recurve", 
      cat_age_class: "Senior", 
      min_age: 21, 
      max_age: 49, 
      open_to_younger: true, 
      open_to_older: true, 
      cat_gender: "Male"
    )
  }

  let(:assoc_category_junior) {
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

  let(:assoc_target) {
    Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  }

  let(:assoc_dist_targ) {
    DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
  }

  # add attr sets for common testing
  # remove any non-required atts, and auto-assign (not auto_format) attrs, all should be formatted correctly already
  let(:valid_req) {
    {username: "testuser2", email: "testuser2@example.com", password: "test", first_name: "Test2", last_name: "User2", birthdate: "2001-10-01", gender: "Female"}
  }

  # exact duplicate of valid_all - use as whole for testing unique values, use for testing specific atttrs (bad inclusion, bad format, etc.)
  let(:duplicate) {
    {username: "testuser", email: "testuser@example.com", password: "test", first_name: "Test", last_name: "User", birthdate: "1980-07-01", gender: "Male", home_city: "Denver", home_state: "CO", home_country: "USA", default_age_class: "Senior"}
  }
  
  # start w/ valid_all, change all values (correctly formatted), make any auto-assign blank (don't delete)
  let(:update) {
    {username: "updateuser", email: "update-user@example.com", password: "test", first_name: "Jane", last_name: "Doe", birthdate: "2001-10-01", gender: "Female", home_city: "Chicago", home_state: "IL", home_country: "USA", default_age_class: ""}
  }

  # every attr blank
  let(:blank) {
    {username: "", email: "", password: "", first_name: "", last_name: "", birthdate: "", gender: "", home_city: "", home_state: "", home_country: "", default_age_class: ""}
  }

  # add default error messages for different validation failures
  let(:default_missing_message) {"can't be blank"}
  let(:default_duplicate_message) {"has already been taken"}
  let(:default_inclusion_message) {"is not included in the list"}
  let(:default_number_message) {"is not a number"}
  let(:default_format_message) {"is invalid"}

  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    before(:each) do
      assoc_category_senior
      assoc_category_junior
    end

    describe "valid with all required and unrequired input data" do
      it "instance is valid with all attributes" do
        expect(Archer.all.count).to eq(0)

        expect(test_archer).to be_valid
        expect(Archer.all.count).to eq(1)
        expect(test_archer.authenticate(valid_all[:password])).to eq(test_archer)

        expect(test_archer.username).to eq(valid_all[:username])
        expect(test_archer.email).to eq(valid_all[:email])
        expect(test_archer.first_name).to eq(valid_all[:first_name])
        expect(test_archer.last_name).to eq(valid_all[:last_name])
        expect(test_archer.birthdate).to eq(valid_all[:birthdate].to_date)
        expect(test_archer.gender).to eq(valid_all[:gender])
        expect(test_archer.home_city).to eq(valid_all[:home_city])
        expect(test_archer.home_state).to eq(valid_all[:home_state])
        expect(test_archer.home_country).to eq(valid_all[:home_country])
        expect(test_archer.default_age_class).to eq(valid_all[:default_age_class])
      end

      it "instance is valid with only required attributes and auto-assigns default age class" do
        expect(Archer.all.count).to eq(0)
        archer = Archer.create(valid_req)
        
        expect(archer).to be_valid
        expect(Archer.all.count).to eq(1)
        expect(archer.authenticate(valid_req[:password])).to eq(archer)
        
        expect(archer.username).to eq(valid_req[:username])
        expect(archer.email).to eq(valid_req[:email])
        expect(archer.first_name).to eq(valid_req[:first_name])
        expect(archer.last_name).to eq(valid_req[:last_name])
        expect(archer.birthdate).to eq(valid_req[:birthdate].to_date)
        expect(archer.gender).to eq(valid_req[:gender])
        expect(archer.default_age_class).to eq("Junior")
      end

      it "instance is valid when updating all attrs and updates default age class" do
        test_archer.update(update)

        expect(test_archer).to be_valid
        expect(test_archer.authenticate(update[:password])).to eq(test_archer)

        expect(test_archer.username).to eq(update[:username])
        expect(test_archer.email).to eq(update[:email])
        expect(test_archer.first_name).to eq(update[:first_name])
        expect(test_archer.last_name).to eq(update[:last_name])
        expect(test_archer.birthdate).to eq(update[:birthdate].to_date)
        expect(test_archer.gender).to eq(update[:gender])
        expect(test_archer.home_city).to eq(update[:home_city])
        expect(test_archer.home_state).to eq(update[:home_state])
        expect(test_archer.home_country).to eq(update[:home_country])
        expect(test_archer.default_age_class).to eq("Junior")
      end
    end

    describe "invalid if input data is missing or bad" do
      it "is invalid and has correct error message without required attributes" do
        archer = Archer.create(blank)

        expect(archer).to be_invalid
        expect(Archer.all.count).to eq(0)
        expect(archer.errors.messages[:username]).to include("You must provide a username.")
        expect(archer.errors.messages[:email]).to include("You must provide your email.")
        expect(archer.errors.messages[:password]).to include(default_missing_message)
        expect(archer.errors.messages[:first_name]).to include("You must provide your first name.")
        expect(archer.errors.messages[:last_name]).to include("You must provide your last name.")
        expect(archer.errors.messages[:birthdate]).to include("You must provide your birthdate.")
        expect(archer.errors.messages[:gender]).to include("You must provide your gender.")
        expect(archer.errors.messages[:default_age_class]).to include(default_missing_message)
      end
    
      it "is invalid and has correct error message when unique attributes are duplicated" do
        test_archer
        expect(Archer.all.count).to eq(1)
        archer = Archer.create(duplicate)

        expect(archer).to be_invalid
        expect(Archer.all.count).to eq(1)
        expect(archer.errors.messages[:username]).to include("That username is already taken.")
        expect(archer.errors.messages[:email]).to include("That email is already taken.")
      end

      it "is invalid and has correct error message if value not included in corresponding selection list" do
        duplicate[:gender] = "bad data"
        duplicate[:default_age_class] = "bad data"
        archer = Archer.create(duplicate)

        expect(archer).to be_invalid
        expect(Archer.all.count).to eq(0)
        expect(archer.errors.messages[:gender]).to include("You can only choose male or female.")
        expect(archer.errors.messages[:default_age_class]).to include(default_inclusion_message)
      end
      
      it "is invalid and has correct error message when username has the wrong format" do
        # has spaces, has special characters, has punctuation
        bad_usernames = ["bad user", "ba$d%u$er", "bad.user!"]

        bad_usernames.each do | test_value |
          duplicate[:username] = test_value
          archer = Archer.create(duplicate)
          expect(archer).to be_invalid
          expect(Archer.all.count).to eq(0)
          expect(archer.errors.messages[:username]).to include("Username can only use letters and numbers without spaces.")
        end
      end

      it "is invalid and has correct error message when email has the wrong format" do
        # has spaces, is missing @ symbol, is missing dot
        # is missing 'com' after dot, has short 'com' after dot, has long 'com' after dot, has invalid 'com' after dot
        # missing local part, missing domain
        bad_emails = ["joe blow@example.com", "joe_blowexample.com", "joe_blow@examplecom", "joe_blow@example.", "joe_blow@example.c", "joe_blow@example.comm", "joe_blow@example.c2m", "@example.com", "joe_blow@.com"]

        bad_emails.each do | test_value |
          duplicate[:email] = test_value
          archer = Archer.create(duplicate)
          expect(archer).to be_invalid
          expect(Archer.all.count).to eq(0)
          expect(archer.errors.messages[:email]).to include("Email doesn't look valid. Please use another.")
        end
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    before(:each) do
      # load all items that must be in DB for test to work
    end

    it "has many ScoreSessions" do
      pending "need to add create associated models and add associations"
      expect(test_archer.score_sessions).to include(assoc_score_session)
    end

    it "has many Rounds" do
      pending "need to add create associated models and add associations"
      expect(test_archer.rounds).to include(assoc_round)
    end

    it "has many RoundSets" do
      pending "need to add create associated models and add associations"
      expect(test_archer.round_sets).to include(assoc_round_set)
    end

    it "has many Shots" do
      pending "need to add create associated models and add associations"
      expect(test_archer.shots).to include(assoc_shot)
    end

    it "has many ArcherCategories" do
      pending "need to add create associated models and add associations"
      expect(test_archer.archer_categories).to include(assoc_category)
    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    before(:each) do
      assoc_category_senior
    end

    it "can return the archer's first and last names with correct capitalization" do
      duplicate[:first_name] = "some"
      duplicate[:last_name] = "tester"
      archer = Archer.create(duplicate)
      expect(archer.first_name).to eq(duplicate[:first_name].capitalize)
      expect(archer.last_name).to eq(duplicate[:last_name].capitalize)
    end

    it "can return the archer's full name with correct capitalization" do
      expect(test_archer.full_name).to eq(valid_all[:first_name].capitalize+" "+valid_all[:last_name].capitalize)
    end

    it "can return the archer's actual age" do
      allow(Date).to receive(:today).and_return Date.new(2020,10,1)
      expect(test_archer.age).to eq(40)

      allow(Date).to receive(:today).and_return Date.new(2020,1,1)
      expect(test_archer.age).to eq(39)
    end
    
    it "can return all the categories the archer is elgibile for" do
      assoc_category_senior
      expect(test_archer.eligbile_categories).to include(assoc_category_senior.name)
    end

    it "can return all the age classes the archer is elgibile for" do
      expect(test_archer.eligbile_age_classes).to include(assoc_category_senior.cat_age_class)
    end

    it "helpers TBD" do
      pending "add as needed"
      expect(archer).to be_invalid
    end
  end
end
