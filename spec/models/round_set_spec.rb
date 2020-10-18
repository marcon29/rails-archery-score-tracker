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

  let(:no_name) {
    {name: "", ends: 6, shots_per_end: 6, score_method: "Points"}
  }

  let(:no_ends) {
    {name: "1440 Round - Set/Distance1", ends: "", shots_per_end: 6, score_method: "Points"}
  }

  let(:no_shots_per_end) {
    {name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: "", score_method: "Points"}
  }

  let(:no_score_method) {
    {name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: ""}
  }

  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
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

    describe "invalid if data missing for:" do
      it "name" do
        round_set = RoundSet.create(no_name)

        expect(round_set).to be_invalid
      end

      it "number of ends" do
        round_set = RoundSet.create(no_ends)

        expect(round_set).to be_invalid
      end
      
      it "shots per end" do
        round_set = RoundSet.create(no_shots_per_end)

        expect(round_set).to be_invalid
      end

      it "score method" do
        round_set = RoundSet.create(no_score_method)

        expect(round_set).to be_invalid
      end
    end

    describe "invalid if a bad value for:" do
      it "name is duplicated" do
        pre_load_round_set
        round_set = RoundSet.create(duplicate)

        expect(round_set).to be_invalid
      end

      it "number of ends not a number" do
        duplicate[:ends] = "six"
        round_set = RoundSet.create(duplicate)

        expect(round_set).to be_invalid
      end

      it "shots per end not a number" do
        duplicate[:shots_per_end] = "six"
        round_set = RoundSet.create(duplicate)

        expect(round_set).to be_invalid
      end

      it "score method not included in corresponding constant" do
        duplicate[:score_method] = "bad data"
        round_set = RoundSet.create(duplicate)

        expect(round_set).to be_invalid
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    it "has many ArcherCategories" do
      pre_load_round_set
      pre_load_target
      rm_category
      dist_targ
      
      expect(pre_load_round_set.archer_categories).to include(rm_category)
    end

    it "has many Targets" do
      pre_load_round_set
      pre_load_target
      rm_category
      dist_targ

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
