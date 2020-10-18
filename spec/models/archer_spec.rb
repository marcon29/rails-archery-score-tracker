require 'rails_helper'

RSpec.describe Archer, type: :model do
  let(:test_archer) {
    Archer.create(
      username: "testuser"
      email: "testuser@example.com"
      password: "password"
      first_name: "test"
      last_name: "user"
      birthdate: Jan 01, 1980
      gender: "Male"
      home_city: "Denver"
      home_state: "CO"
      home_country: "USA"
      # default_cat:
    )
  }

  let(:test_score_session) {
    # ScoreSession.create()
  }

  let(:test_round) {
    # Round.create()
  }

  let(:pre_load_round_set) {
    RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
  }

  let(:test_shot) {
    # Shot.create()
  }
  
  let(:rm_category) {
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

  let(:pre_load_target) {
    Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  }

  let(:dist_targ) {
    DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
  }

  let(:duplicate) {
    {}
  }
  
  let(:update) {
    {}
  }

  let(:no_username) {
    {}
  }

  let(:no_email) {
    {}
  }

  let(:no_password) {
    {}
  }

  let(:no_first_name) {
    {}
  }

  let(:no_last_name) {
    {}
  }

  let(:no_birthdate) {
    {}
  }

  let(:no_gender) {
    {}
  }

  # object creation and validation tests #######################################
  describe "model creates valid instances:" do
    it "archer is valid and creates correct default category" do
      expect(test_archer).to be_valid
      expect(test_archer.username).to eq("testuser")
      expect(test_archer.email).to eq("testuser@example.com")
      # expect(test_archer.password).to eq("password")
      expect(test_archer.first_name).to eq("test")
      expect(test_archer.last_name).to eq("user")
      expect(test_archer.birthdate).to eq(Jan 01, 1980)
      expect(test_archer.gender).to eq("Male")
      expect(test_archer.home_city).to eq("Denver")
      expect(test_archer.home_state).to eq("CO")
      expect(test_archer.home_country).to eq("USA")
      expect(test_archer.default_cat).to eq("TBD")
    end

    describe "invalid and has correct error message if data missing for:" do
      it "username" do
        archer = Archer.create(no_username)

        expect(archer).to be_invalid
        expect(archer.errors.messages[:username]).to include("You must provide a username.")
      end

      it "email" do
        archer = Archer.create(no_email)

        expect(archer).to be_invalid
        expect(archer.errors.messages[:email]).to include("You must provide your email.")
      end
      
      it "password" do
        archer = Archer.create(no_password)
        
        expect(archer).to be_invalid
        expect(archer.errors.messages[:password]).to include("You must provide a password.")
      end

      it "first_name" do
        archer = Archer.create(no_first_name)
        
        expect(archer).to be_invalid
        expect(archer.errors.messages[:first_name]).to include("You must provide your first name.")
      end

      it "last_name" do
        archer = Archer.create(no_last_name)
        
        expect(archer).to be_invalid
        expect(archer.errors.messages[:last_name]).to include("You must provide your last name.")
      end

      it "birthdate" do
        archer = Archer.create(no_birthdate)
        
        expect(archer).to be_invalid
        expect(archer.errors.messages[:birthdate]).to include("You must provide your birthdate.")
      end

      it "gender" do
        archer = Archer.create(no_gender)
        
        expect(archer).to be_invalid
        expect(archer.errors.messages[:gender]).to include("You must provide your gender.")
      end
    end

    describe "invalid and has correct error message if a bad value for:" do
      it "username or email being duplicated" do
        test_archer
        archer = Archer.create(duplicate)

        expect(archer).to be_invalid
        expect(archer.errors.messages[:username]).to include("That username is already taken.")
        expect(archer.errors.messages[:email]).to include("That email is already taken")
      end

      it "username not being properly formatted" do

        expect(archer).to be_invalid
      end

      it "email not being properly formatted" do
        
        expect(archer).to be_invalid
      end

      it "password not being properly formatted" do

        expect(archer).to be_invalid
      end

      it "gender not included in corresponding constant" do
        duplicate[:gender] = "bad data"
        archer = Archer.create(duplicate)

        expect(archer).to be_invalid
        expect(archer.errors.messages[:username]).to include("You must choose a gender from the list.")
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    it "has many ScoreSessions" do
      pending "need to add associations"
      pending "need to create Shots model"
      pending "need to finish RoundSets model"
      pending "need to create Rounds model"
      pending "need to create ScoreSessions model"

      # load all items that must be in DB for test to work
      
      expect(test_archer.score_sessions).to include(test_score_session)
    end

    it "has many Rounds" do
      pending "need to add associations"
      pending "need to create Shots model"
      pending "need to finish RoundSets model"
      pending "need to create Rounds model"
      pending "need to create ScoreSessions model"

      # load all items that must be in DB for test to work
      
      expect(test_archer.rounds).to include(test_round)
    end

    it "has many RoundSets" do
      pending "need to add associations"
      pending "need to create Shots model"
      pending "need to finish RoundSets model"
      pending "need to create Rounds model"
      pending "need to create ScoreSessions model"

      # load all items that must be in DB for test to work
      
      expect(test_archer.round_sets).to include(pre_load_round_set)
    end

    it "has many Shots" do
      pending "need to add associations"
      pending "need to create Shots model"
      pending "need to finish RoundSets model"
      pending "need to create Rounds model"
      pending "need to create ScoreSessions model"

      # load all items that must be in DB for test to work
      
      expect(test_archer.shots).to include(test_shot)
    end

    it "has many ArcherCategories" do
      pending "need to add associations"
      pending "need to create Shots model"
      pending "need to finish RoundSets model"
      pending "need to create Rounds model"
      pending "need to create ScoreSessions model"

      # load all items that must be in DB for test to work
      
      expect(test_archer.archer_categories).to include(rm_category)
    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "helpers TBD" do
      pending "add as needed"
      expect(archer).to be_invalid
    end
  end
end
