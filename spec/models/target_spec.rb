require 'rails_helper'

RSpec.describe Target, type: :model do
  let(:pre_load_target) {
    Target.create(
      size: "122cm", 
      score_areas: 10, 
      rings: 10, 
      x_ring: true, 
      max_score: 10, 
      spots: 1, 
      user_edit: false
    )
  }

  let(:user_load_target) {
    Target.create(
      size: "20in", 
      score_areas: 2, 
      rings: 4, 
      x_ring: true, 
      max_score: 5, 
      spots: 5
    )
  }

  let(:update_values) {
      size: "40cm", 
      score_areas: 6, 
      rings: 6, 
      x_ring: true, 
      max_score: 10, 
      spots: 3
  }

  # object creation and validation tests #######################################
  describe "model creates and updates valid instances:" do
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

    it "will auto-create the target name and won't save unless it's unique" do
      # name is what it should be
      # duplicate name won't instantiate
    end
    
    it "won't create a target without a size" do
    end

    it "won't create a target without # of score areas specified" do
    end

    it "won't create a target without # of rings specified" do
    end

    it "won't create a target without having an x-ring specified" do
    end

    it "won't create a target without the max score specified" do
    end

    it "won't create a target without # of spots specified" do
    end

    it "won't update a pre-loaded (non-user-editable) target" do
      pre_load_target.update(update_values)

      expect(pre_load_target.name).to eq("122cm/1-spot/10-ring")
      expect(pre_load_target.size).to eq("122cm")
      expect(pre_load_target.score_areas).to eq(10)
      expect(pre_load_target.rings).to eq(10)
      expect(pre_load_target.x_ring).to eq(true)
      expect(pre_load_target.max_score).to eq(10)
      expect(pre_load_target.spots).to eq(1)
    end

    it "updates the name if the size, spots or rings are edited" do
      user_target.update(update_values)

      expect(user_target.name).to eq("40cm/3-spot/6-ring")
      expect(user_target.size).to eq("40cm")
      expect(user_target.score_areas).to eq(6)
      expect(user_target.rings).to eq(6)
      expect(user_target.x_ring).to eq(true)
      expect(user_target.max_score).to eq(10)
      expect(user_target.spots).to eq(3)
    end
    
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    it "has many Sets" do
    end

    it "has many ArcherCategories" do
    end





  end
  
  # helper method tests ########################################################
  describe "all helper methods work correctly" do
    it "can identify all possible score values" do
      # max_score..score_areas, M, and X if x_ring
    end





  end



  # these should be for the shot model
  # it "will only allows score values up to the number of score areas, M and X" do
  # end

  # it "won't allow allow a score value of X if there is no x-ring" do
  # end


end



