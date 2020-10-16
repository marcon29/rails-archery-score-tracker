require 'rails_helper'

RSpec.describe ArcherCategory, type: :model do
  let(:rjm_category) {
    rjm_category = ArcherCategory.create(
      cat_code: "WA-RJM", 
      gov_body: "World Archery", 
      cat_division: "Recurve", 
      cat_age_class: "Junior", 
      min_age: 18, 
      max_age: 20, 
      open_to_younger: true, 
      open_to_older: false, 
      cat_gender: "Male"
    )
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

  let(:usrm_category) {
    usrm_category = ArcherCategory.create(
      cat_code: "USA-RM", 
      gov_body: "USA Archery", 
      cat_division: "Recurve", 
      cat_age_class: "Senior", 
      min_age: 21, 
      max_age: 49, 
      open_to_younger: true, 
      open_to_older: true, 
      cat_gender: "Male"
    )
  }

  let(:rmm_category) {
    rmm_category = ArcherCategory.create(
      cat_code: "WA-RMM", 
      gov_body: "World Archery", 
      cat_division: "Recurve", 
      cat_age_class: "Master", 
      min_age: 50, 
      max_age: "", 
      open_to_younger: false, 
      open_to_older: true, 
      cat_gender: "Male"
    )
  }

  let(:cm60w_category) {
    cm60w_category = ArcherCategory.create(
      cat_code: "USA-CM60F", 
      gov_body: "USA Archery", 
      cat_division: "Compound", 
      cat_age_class: "Master60", 
      min_age: 60, 
      max_age: 69, 
      open_to_younger: false, 
      open_to_older: true, 
      cat_gender: "Female"
    )
  }

  let(:pre_load_target) {
    Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  }

  # need to create a Set to associate category to
  # set = Set.create()
  
  let(:no_code) {
    {cat_code: "", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}
  }

  let(:no_gov_body) {
    {cat_code: "WA-RM", gov_body: "", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}
  }

  let(:no_division) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}
  }

  let(:no_class) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}
  }

  let(:no_gender) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: ""}
  }

  let(:duplicate) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}
  }

  # object creation and validation tests #######################################
  describe "model creates and updates valid instances:" do
    it "pre-loaded category is valid with all values except min and max age" do
      expect(rm_category).to be_valid
      expect(rm_category.cat_code).to eq("WA-RM")
      expect(rm_category.gov_body).to eq("World Archery")
      expect(rm_category.cat_division).to eq("Recurve")
      expect(rm_category.cat_age_class).to eq("Senior")
      expect(rm_category.min_age).to eq(21)
      expect(rm_category.max_age).to eq(49)
      expect(rm_category.open_to_younger).to eq(true)
      expect(rm_category.open_to_older).to eq(true)
      expect(rm_category.cat_gender).to eq("Male")
    end

    describe "invalid if data missing or duplicated for:" do
      it "category code (duplicated)" do
        rm_category
        category = ArcherCategory.create(duplicate)
        expect(category).to be_invalid
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
      expect(rm_category.name).to eq("Recurve-Senior-Men")
    end

    it "can calculate a default category with Archer data" do
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category

      junior_data = {div: "Recurve", age: 16, gender: "Male"}
      senior_data = {div: "Recurve", age: 25, gender: "Male"}
      master_data = {div: "Recurve", age: 55, gender: "Male"}
      master60_data = {div: "Compound", age: 65, gender: "Female"}

      junior = ArcherCategory.default_by_archer_data(junior_data[:div], junior_data[:age], junior_data[:gender])
      senior = ArcherCategory.default_by_archer_data(senior_data[:div], senior_data[:age], senior_data[:gender])
      master = ArcherCategory.default_by_archer_data(master_data[:div], master_data[:age], master_data[:gender])
      master60 = ArcherCategory.default_by_archer_data(master60_data[:div], master60_data[:age], master60_data[:gender])

      expect(junior).to include(rjm_category)
      expect(junior).to_not include(rm_category)
      expect(junior).to_not include(usrm_category)
      expect(junior).to_not include(rmm_category)
      expect(junior).to_not include(cm60w_category)

      expect(senior).to_not include(rjm_category)
      expect(senior).to include(rm_category)
      expect(senior).to include(usrm_category)
      expect(senior).to_not include(rmm_category)
      expect(senior).to_not include(cm60w_category)

      expect(master).to_not include(rjm_category)
      expect(master).to_not include(rm_category)
      expect(master).to_not include(usrm_category)
      expect(master).to include(rmm_category)
      expect(master).to_not include(cm60w_category)
      
      expect(master60).to_not include(rjm_category)
      expect(master60).to_not include(rm_category)
      expect(master60).to_not include(usrm_category)
      expect(master60).to_not include(rmm_category)
      expect(master60).to include(cm60w_category)
    end

    it "can calculate a default category by user selection" do
      pending "need to create - uses a selection from the user"
      junior_data = {div: "Recurve", age: 16, gen: "Male"}
      
      expect(ArcherCategory.default_by_selection).to eq(rjm_category)
    end

    it "can calculate all eligbile categories by Archer age and gender" do
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category

      junior_data = {age: 16, gender: "Male"}
      senior_data = {age: 25, gender: "Male"}
      master_data = {age: 55, gender: "Male"}
      master60_data = {age: 65, gender: "Female"}

      junior = ArcherCategory.eligible(junior_data[:age], junior_data[:gender])
      senior = ArcherCategory.eligible(senior_data[:age], senior_data[:gender])
      master = ArcherCategory.eligible(master_data[:age], master_data[:gender])
      master60 = ArcherCategory.eligible(master60_data[:age], master60_data[:gender])

      expect(junior).to include(rjm_category)
      expect(junior).to include(rm_category)
      expect(junior).to include(usrm_category)
      expect(junior).to_not include(rmm_category)
      expect(junior).to_not include(cm60w_category)

      expect(senior).to_not include(rjm_category)
      expect(senior).to include(rm_category)
      expect(senior).to include(usrm_category)
      expect(senior).to_not include(rmm_category)
      expect(senior).to_not include(cm60w_category)

      expect(master).to_not include(rjm_category)
      expect(master).to include(rm_category)
      expect(master).to include(usrm_category)
      expect(master).to include(rmm_category)
      expect(master).to_not include(cm60w_category)
      
      expect(master60).to_not include(rjm_category)
      expect(master60).to_not include(rm_category)
      expect(master60).to_not include(usrm_category)
      expect(master60).to_not include(rmm_category)
      expect(master60).to include(cm60w_category)
    end

    it "helper methods TBD" do
      pending "add as needed - move commented out tests to Archer model"
      expect(junior).to eq(rjm_category)
    end
    
  end
  
 


end

