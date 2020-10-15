require 'rails_helper'

RSpec.describe Target, type: :model do
  let(:pre_load_target) {
    Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  }

  let(:user_target) {
    Target.create(size: "20in", score_areas: 2, rings: 4, x_ring: true, max_score: 5, spots: 5)
  }

  # need to create a ArcherCategory to associate target to
  
  # need to create a Set to associate target to

  let(:update_values) {
    {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3}
  }
  
  let(:no_size) {
    {size: "", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3}
  }
  
  let(:no_score_areas) {
    {size: "40cm", score_areas: "", rings: 6, x_ring: true, max_score: 10, spots: 3}
  }
  
  let(:no_rings) {
    {size: "40cm", score_areas: 6, rings: "", x_ring: true, max_score: 10, spots: 3}
  }
  
  let(:no_x_ring) {
    {size: "40cm", score_areas: 6, rings: 6, x_ring: "", max_score: 10, spots: 3}
  }
  
  let(:no_max_score) {
    {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: "", spots: 3}
  }

  let(:no_spots) {
    {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: ""}
  }

  let(:duplicate) {
    {size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1}
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

    it "will auto-create the target name, won't save unless it's unique, and display correct error message" do
      dup_target = Target.create(duplicate)
      
      expect(dup_target.name).to eq("122cm/1-spot/10-ring")
      expect(dup_target).to be_invalid
      expect(dup_target.errors.messages[:name]).to include("error message")
    end
    
    it "is invalid without a size and has correct error message" do
      target = Target.create(no_size)
      expect(target).to be_invalid
      expect(target.errors.messages[:size]).to include("error message")
    end

    it "is invalid without # of score areas specified and has correct error message" do
      target = Target.create(no_score_areas)

      expect(target).to be_invalid
      expect(target.errors.messages[:score_areas]).to include("error message")
    end

    it "is invalid without # of rings specified and has correct error message" do
      target = Target.create(no_rings)

      expect(target).to be_invalid
      expect(target.errors.messages[:rings]).to include("error message")
    end

    it "is invalid without having an x-ring specified and has correct error message" do
      target = Target.create(no_x_ring)

      expect(target).to be_invalid
      expect(target.errors.messages[:x_ring]).to include("error message")
    end

    it "is invalid without the max score specified and has correct error message" do
      target = Target.create(no_max_score)

      expect(target).to be_invalid
      expect(target.errors.messages[:max_score]).to include("error message")
    end

    it "is invalid without # of spots specified and has correct error message" do
      target = Target.create(no_spots)

      expect(target).to be_invalid
      expect(target.errors.messages[:spots]).to include("error message")
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
      pending "need to create Set model"
    end

    it "has many ArcherCategories" do
      pending "need to create ArcherCategory model"
    end
  end
  
  # helper method tests ########################################################
  describe "all helper methods work correctly" do
    it "helper methods TBD" do
      pending "add as needed - move commented out tests to Shot model"
    end
  end



  # these should be for the shot model

  # it "can identify all possible score values" do
  #   # max_score..score_areas, M, and X if x_ring
  # end

  # it "will only allows score values up to the number of score areas, M and X" do
  # end

  # it "won't allow allow a score value of X if there is no x-ring" do
  # end


end



