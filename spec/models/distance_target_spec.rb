require 'rails_helper'

RSpec.describe DistanceTarget, type: :model do
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

  let(:blank) {
    {distance: "", target_id: "", archer_category_id: "", round_set_id: ""}
  }
  
  let(:default_missing_message) {"can't be blank"}
  let(:default_duplicate_message) {"has already been taken"}
  let(:default_inclusion_message) {"is not included in the list"}

  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    describe "valid with all required and unrequired input data" do
      it "pre-loaded distance/target is valid and has correct distance" do
        pre_load_target
        rm_category
        pre_load_round_set

        expect(dist_targ).to be_valid
        expect(dist_targ.distance).to eq("90m")
      end
    end

    describe "invalid if input data is missing or bad" do
      it "is invalid without required attributes and has correct error message" do
        bad_dist_targ = DistanceTarget.create(blank)

        expect(bad_dist_targ).to be_invalid
        expect(bad_dist_targ.errors.messages[:distance]).to include(default_missing_message)
        expect(bad_dist_targ.errors.messages[:target_id]).to include(default_missing_message)
        expect(bad_dist_targ.errors.messages[:archer_category_id]).to include(default_missing_message)
        expect(bad_dist_targ.errors.messages[:round_set_id]).to include(default_missing_message)
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    it "belongs to a RoundSet" do
      pre_load_round_set
      expect(dist_targ.round_set).to eq(pre_load_round_set)
    end

    it "belongs to an ArcherCategory" do
      rm_category
      expect(dist_targ.archer_category).to eq(rm_category)
    end

    it "belongs to a Target" do
      pre_load_target
      expect(dist_targ.target).to eq(pre_load_target)
    end
  end

  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "can create a properly formatted distance from number and unit" do
      user_dist_targ = DistanceTarget.new
      calc_distance = user_dist_targ.distance_from_input(70, "m")
      expect(calc_distance).to eq("70m")
    end
  end
end
