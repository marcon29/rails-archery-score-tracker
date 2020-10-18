require 'rails_helper'

RSpec.describe RoundSet, type: :model do
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

  let(:pre_load_round_set) {
    RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
  }

  let(:dist_targ) {
    DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
  }

  let(:duplicate) {
    {name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points"}
  }

  let(:blank) {
    {name: "", ends: "", shots_per_end: "", score_method: ""}
  }

  let(:bad_inclusion) {
    {name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "bad data"}
  }

  let(:bad_format) {
    {name: "1440 Round - Set/Distance1", ends: "six", shots_per_end: "six", score_method: "Points"}
  }
  
  let(:default_missing_message) {"can't be blank"}
  let(:default_duplicate_message) {"has already been taken"}
  let(:default_inclusion_message) {"is not included in the list"}
  let(:default_number_message) {"is not a number"}

  
  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    describe "valid with all required and unrequired input data" do
      it "pre-loaded roundset (name provided) is valid" do
        expect(pre_load_round_set).to be_valid
        expect(pre_load_round_set.name).to eq("1440 Round - Set/Distance1")
        expect(pre_load_round_set.ends).to eq(6)
        expect(pre_load_round_set.shots_per_end).to eq(6)
        expect(pre_load_round_set.score_method).to eq("Points")
      end

      it "user-loaded roundset (without name provided) is valid and has correct name" do
        pending "need this???"
        user_round_set = RoundSet.create(no_name)

        expect(user_round_set).to be_valid
        expect(user_round_set.name).to eq("1440 Round - Set/Distance1")
      end

      it "will auto-create the roundset name, won't save unless it's unique" do
        pending "need this???"
        pre_load_round_set
        dup_round_set = RoundSet.create(no_name)
        
        expect(dup_round_set.name).to eq("1440 Round - Set/Distance1")
        expect(dup_round_set).to be_invalid
      end
    end

    describe "invalid if input data is missing or bad" do
      it "is invalid without required attributes and has correct error message" do
        round_set = RoundSet.create(blank)

        expect(round_set).to be_invalid
        expect(round_set.errors.messages[:name]).to include(default_missing_message)
        expect(round_set.errors.messages[:ends]).to include(default_number_message)
        expect(round_set.errors.messages[:shots_per_end]).to include(default_number_message)
        expect(round_set.errors.messages[:score_method]).to include(default_missing_message)
      end
    
      it "is invalid when unique attributes are duplicated and has correct error message" do
        pre_load_round_set
        round_set = RoundSet.create(duplicate)

        expect(round_set).to be_invalid
        expect(round_set.errors.messages[:name]).to include(default_duplicate_message)
      end

      it "is invalid if value not included in corresponding selection list and has correct error message" do
        round_set = RoundSet.create(bad_inclusion)

        expect(round_set).to be_invalid
        expect(round_set.errors.messages[:score_method]).to include(default_inclusion_message)
      end

      it "is invalid when attributes are the wrong format and has correct error message" do
        round_set = RoundSet.create(bad_format)
        
        expect(round_set).to be_invalid
        expect(round_set.errors.messages[:ends]).to include(default_number_message)
        expect(round_set.errors.messages[:shots_per_end]).to include(default_number_message)
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    before(:each) do
      pre_load_round_set
      pre_load_target
      rm_category
      dist_targ
    end

    it "has many ArcherCategories" do
      expect(pre_load_round_set.archer_categories).to include(rm_category)
    end

    it "has many Targets" do
      expect(pre_load_round_set.targets).to include(pre_load_target)
    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "helpers TBD" do
      pending "add as needed"
      expect(pre_load_round_set).to be_invalid
    end
  end
end
