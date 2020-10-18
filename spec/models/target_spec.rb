require 'rails_helper'

RSpec.describe Target, type: :model do
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

  let(:user_target) {
    Target.create(size: "20in", score_areas: 2, rings: 4, x_ring: true, max_score: 5, spots: 5)
  }
  
  let(:pre_load_round_set) {
    RoundSet.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
  }

  let(:dist_targ) {
    DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
  }

  let(:update) {
    {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3}
  }

  let(:duplicate) {
    {size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1}
  }

  let(:blank) {
    {size: "", score_areas: "", rings: "", x_ring: "", max_score: "", spots: "", user_edit: ""}
  }

  let(:default_missing_message) {"can't be blank"}
  let(:default_duplicate_message) {"has already been taken"}
  let(:default_inclusion_message) {"is not included in the list"}

  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    describe "valid with all required and unrequired input data" do
      it "pre-loaded target (without name provided) is valid, has correct name, and is marked not user-editable" do
        expect(pre_load_target).to be_valid
        expect(pre_load_target.name).to eq("122cm/1-spot/10-ring")
        expect(pre_load_target.user_edit).to eq(false)
      end
    
      it "user-loaded target (without name or user_edit provided) is valid, has correct name, and is marked user-editable" do
        expect(user_target).to be_valid
        expect(user_target.name).to eq("20in/5-spot/4-ring")
        expect(user_target.user_edit).to eq(true)
      end

      it "will auto-create the target name, won't save unless it's unique" do
        pre_load_target
        target = Target.create(duplicate)
        
        expect(target.name).to eq("122cm/1-spot/10-ring")
        expect(target).to be_invalid
      end

      it "updates the name if the size, spots or rings are edited" do
        user_target.update(update)

        expect(user_target.name).to eq("40cm/3-spot/6-ring")
        expect(user_target.size).to eq("40cm")
        expect(user_target.score_areas).to eq(6)
        expect(user_target.rings).to eq(6)
        expect(user_target.x_ring).to eq(true)
        expect(user_target.max_score).to eq(10)
        expect(user_target.spots).to eq(3)
      end
    end

    describe "invalid if input data is missing or bad" do
      it "is invalid without required attributes and has correct error message" do
        target = Target.create(blank)

        expect(target).to be_invalid
        expect(target.errors.messages[:size]).to include("You must provide a target size.")
        expect(target.errors.messages[:score_areas]).to include("You must provide the number of scoring areas.")
        expect(target.errors.messages[:rings]).to include("You must provide the number of rings.")
        expect(target.errors.messages[:x_ring]).to include("You must specifiy if there is an X ring.")
        expect(target.errors.messages[:max_score]).to include("You must provide the higest score value.")
        expect(target.errors.messages[:spots]).to include("You must specify the number of spots.")
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

    it "has many RoundSets" do
      expect(pre_load_target.round_sets).to include(pre_load_round_set)
    end

    it "has many ArcherCategories" do
      expect(pre_load_target.archer_categories).to include(rm_category)
    end
  end
end



