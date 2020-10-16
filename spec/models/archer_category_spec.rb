require 'rails_helper'

RSpec.describe ArcherCategory, type: :model do
  let(:rm_category) {
    ArcherCategory.create(cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: "", max_age: "", cat_gender: "Male")
  }
  
  # ####################################
  # ####################################
  # only need these for default cat helper (for working with different age ranges)
  let(:cjw_category) {
    ArcherCategory.create(cat_code: "WA-CJW", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Junior", min_age: "", max_age: 20, cat_gender: "Female")
  }

  let(:cm60w_category) {
    ArcherCategory.create(cat_code: "USA-CM60W", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master60", min_age: 60, max_age: "", cat_gender: "Female")
  } 
  # ####################################
  # ####################################

  let(:pre_load_target) {
    Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  }
  
  # need to create a Set to associate category to
  # let(:set) {
  #   Set.create()
  # }

  let(:no_code) {
    {cat_code: "", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: "", max_age: "", cat_gender: "Male"}
  }

  let(:no_gov_body) {
    {cat_code: "WA-RM", gov_body: "", cat_division: "Recurve", cat_age_class: "Senior", min_age: "", max_age: "", cat_gender: "Male"}
  }

  let(:no_division) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "", cat_age_class: "Senior", min_age: "", max_age: "", cat_gender: "Male"}
  }

  let(:no_class) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "", min_age: "", max_age: "", cat_gender: "Male"}
  }

  let(:no_gender) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: "", max_age: "", cat_gender: ""}
  }

  let(:duplicate) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: "", max_age: "", cat_gender: "Male"}
  }

  # object creation and validation tests #######################################
  describe "model creates and updates valid instances:" do
    it "pre-loaded category is valid with all values except min and max age" do
      expect(rm_category).to be_valid
      expect(rm_category.cat_code).to eq("WA-RM")
      expect(rm_category.gov_body).to eq("World Archery")
      expect(rm_category.cat_division).to eq("Recurve")
      expect(rm_category.cat_age_class).to eq("Senior")
      expect(rm_category.min_age).to eq(nil)
      expect(rm_category.max_age).to eq(nil)
      expect(rm_category.cat_gender).to eq("Male")
    end

    describe "invalid if data missing or duplicated for:" do
      it "category code (duplicated)" do
        category = ArcherCategory.create(duplicate)
        expect(rm_category).to be_invalid
      end
    
      it "category code (missing)" do
        category = ArcherCategory.create(no_code)
        expect(category).to be_invalid
      end

      it "governing body (missing)" do
        category = ArcherCategory.create(no_gov_body)
        expect(category).to be_invalid
      end

      it "division (missing)" do
        category = ArcherCategory.create(no_division)
        expect(category).to be_invalid
      end

      it "age class (missing)" do
        category = ArcherCategory.create(no_class)
        expect(category).to be_invalid
      end

      it "gender (missing)" do
        category = ArcherCategory.create(no_gender)
        expect(category).to be_invalid
      end
    end

    describe "invalid if value not included in corresponding constant for:" do
      it "governing body" do
        duplicate[:gov_body] = "bad data"
        category = ArcherCategory.create(duplicate)
        expect(category).to be_invalid
      end
      
      it "division" do
        duplicate[:cat_division] = "bad data"
        category = ArcherCategory.create(duplicate)
        expect(category).to be_invalid
      end
      
      it "age class" do
        duplicate[:cat_age_class] = "bad data"
        category = ArcherCategory.create(duplicate)
        expect(category).to be_invalid
      end

      it "gender" do
        duplicate[:cat_gender] = "bad data"
        category = ArcherCategory.create(duplicate)
        expect(category).to be_invalid
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    it "has many Sets" do
      pending "need to create Set model"
      pending "need to create DistanceTarget model"
      expect(rm_category.sets).to include(set)
    end

    it "has many Targets" do
      pending "need to create DistanceTarget model"
      expect(rm_category.targets).to include(pre_load_target)
    end
  end
  
  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "has a user-friendly display name" do
      pending "need to create"
    end

    it "can calculate a default category" do
      pending "need to create - uses division/age/gender data - delete instances above if not using here"
    end

    it "helper methods TBD" do
      pending "add as needed - move commented out tests to Archer model"
    end
    
  end
  
  # need to use to set as default for Archer
    # can't associate category w/ archer - archer can shoot differing categories by ScoreSession - simply use as identifier
    # need to assign a category as the default category based off of Archer data (in Archer model)
        # archer.default_cat = archer_category.cat_code

  # this will have to be part of ArcherCat controller tests
    # NOTE: need to restrict so user can't update any items from this model
    # let(:update_values) {
    #   {cat_code: "USA-CM60W", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master60", min_age: 60, max_age: "", cat_gender: "Female"}
    # }
    # it "won't update a pre-loaded (non-user-editable) category" do
    #   rm_category.update(update_values)
      
    #   expect(rm_category.cat_code).to eq("WA-RM")
    #   expect(rm_category.gov_body).to eq("World Archery")
    #   expect(rm_category.cat_division).to eq("Recurve")
    #   expect(rm_category.cat_age_class).to eq("Senior")
    #   expect(rm_category.min_age).to eq(nil)
    #   expect(rm_category.max_age).to eq(nil)
    #   expect(rm_category.cat_gender).to eq("Male")
    # end


end

