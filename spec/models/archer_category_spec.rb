require 'rails_helper'

RSpec.describe ArcherCategory, type: :model do
  let(:rcm_category) {
    ArcherCategory.create(
      cat_code: "WA-RCM", 
      gov_body: "World Archery", 
      cat_division: "Recurve", 
      cat_age_class: "Cadet", 
      min_age: "", 
      max_age: 17, 
      open_to_younger: true, 
      open_to_older: false, 
      cat_gender: "Male"
    )
  }

  let(:rjm_category) {
    ArcherCategory.create(
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
    ArcherCategory.create(
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
    ArcherCategory.create(
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
    ArcherCategory.create(
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

  # need to create a Set to associate
  # let(:pre_load_set) {
  #   Set.create()
  # }

  let(:dist_targ) {
    DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
  }
  
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
    it "pre-loaded category is valid with all values and correctly adds min and max age if missing" do
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

    it "pre-loaded category correctly adds min and max age if missing" do
      expect(rcm_category.min_age).to eq(0)
      expect(rcm_category.max_age).to eq(17)

      expect(rmm_category.min_age).to eq(50)
      expect(rmm_category.max_age).to eq(1000)
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
      pending "need to add associations"
      pending "need to create Set model"
      pre_load_set
      pre_load_target
      rm_category
      dist_targ
      
      expect(rm_category.sets).to include(pre_load_set)
    end

    it "has many Targets" do
      # pre_load_set
      pre_load_target
      rm_category
      dist_targ

      expect(rm_category.targets).to include(pre_load_target)
    end
  end
  
  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    it "has a user-friendly display name" do
      expect(rm_category.name).to eq("Recurve-Senior-Men")
    end

    it "can calculate default categories with Archer data" do
      rcm_category
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category

      cadet_data = {division: "Recurve", age: 17, gender: "Male"}
      junior_data = {division: "Recurve", age: 20, gender: "Male"}
      senior_data = {division: "Recurve", age: 21, gender: "Male"}
      senior_data_two = {division: "Recurve", age: 49, gender: "Male"}
      master_data = {division: "Recurve", age: 50, gender: "Male"}
      master60_data = {division: "Compound", age: 60, gender: "Female"}

      cadet = ArcherCategory.default(cadet_data[:division], cadet_data[:age], cadet_data[:gender])
      junior = ArcherCategory.default(junior_data[:division], junior_data[:age], junior_data[:gender])
      senior = ArcherCategory.default(senior_data[:division], senior_data[:age], senior_data[:gender])
      senior_two = ArcherCategory.default(senior_data_two[:division], senior_data_two[:age], senior_data_two[:gender])
      master = ArcherCategory.default(master_data[:division], master_data[:age], master_data[:gender])
      master60 = ArcherCategory.default(master60_data[:division], master60_data[:age], master60_data[:gender])
      
      expect(cadet).to include(rcm_category)
      expect(cadet).to_not include(rjm_category)
      expect(cadet).to_not include(rm_category)
      expect(cadet).to_not include(usrm_category)
      expect(cadet).to_not include(rmm_category)
      expect(cadet).to_not include(cm60w_category)

      expect(junior).to_not include(rcm_category)
      expect(junior).to include(rjm_category)
      expect(junior).to_not include(rm_category)
      expect(junior).to_not include(usrm_category)
      expect(junior).to_not include(rmm_category)
      expect(junior).to_not include(cm60w_category)

      expect(senior).to_not include(rcm_category)
      expect(senior).to_not include(rjm_category)
      expect(senior).to include(rm_category)
      expect(senior).to include(usrm_category)
      expect(senior).to_not include(rmm_category)
      expect(senior).to_not include(cm60w_category)

      expect(senior_two).to_not include(rcm_category)
      expect(senior_two).to_not include(rjm_category)
      expect(senior_two).to include(rm_category)
      expect(senior_two).to include(usrm_category)
      expect(senior_two).to_not include(rmm_category)
      expect(senior_two).to_not include(cm60w_category)

      expect(master).to_not include(rcm_category)
      expect(master).to_not include(rjm_category)
      expect(master).to_not include(rm_category)
      expect(master).to_not include(usrm_category)
      expect(master).to include(rmm_category)
      expect(master).to_not include(cm60w_category)
      
      expect(master60).to_not include(rcm_category)
      expect(master60).to_not include(rjm_category)
      expect(master60).to_not include(rm_category)
      expect(master60).to_not include(usrm_category)
      expect(master60).to_not include(rmm_category)
      expect(master60).to include(cm60w_category)
    end

    it "can find all eligbile categories by Archer age and gender" do
      rcm_category
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category

      cadet_data = {age: 17, gender: "Male"}
      junior_data = {age: 19, gender: "Male"}
      senior_data = {age: 21, gender: "Male"}
      senior_data_two = {age: 49, gender: "Male"}
      master_data = {age: 50, gender: "Male"}
      master60_data = {age: 60, gender: "Female"}

      cadet = ArcherCategory.eligible_categories(cadet_data[:age], cadet_data[:gender])
      junior = ArcherCategory.eligible_categories(junior_data[:age], junior_data[:gender])
      senior = ArcherCategory.eligible_categories(senior_data[:age], senior_data[:gender])
      senior_two = ArcherCategory.eligible_categories(senior_data_two[:age], senior_data_two[:gender])
      master = ArcherCategory.eligible_categories(master_data[:age], master_data[:gender])
      master60 = ArcherCategory.eligible_categories(master60_data[:age], master60_data[:gender])

      expect(cadet).to include(rcm_category)
      expect(cadet).to include(rjm_category)
      expect(cadet).to include(rm_category)
      expect(cadet).to include(usrm_category)
      expect(cadet).to_not include(rmm_category)
      expect(cadet).to_not include(cm60w_category)

      expect(junior).to_not include(rcm_category)
      expect(junior).to include(rjm_category)
      expect(junior).to include(rm_category)
      expect(junior).to include(usrm_category)
      expect(junior).to_not include(rmm_category)
      expect(junior).to_not include(cm60w_category)

      expect(senior).to_not include(rcm_category)
      expect(senior).to_not include(rjm_category)
      expect(senior).to include(rm_category)
      expect(senior).to include(usrm_category)
      expect(senior).to_not include(rmm_category)
      expect(senior).to_not include(cm60w_category)

      expect(senior_two).to_not include(rcm_category)
      expect(senior_two).to_not include(rjm_category)
      expect(senior_two).to include(rm_category)
      expect(senior_two).to include(usrm_category)
      expect(senior_two).to_not include(rmm_category)
      expect(senior_two).to_not include(cm60w_category)

      expect(master).to_not include(rcm_category)
      expect(master).to_not include(rjm_category)
      expect(master).to include(rm_category)
      expect(master).to include(usrm_category)
      expect(master).to include(rmm_category)
      expect(master).to_not include(cm60w_category)
      
      expect(master60).to_not include(rcm_category)
      expect(master60).to_not include(rjm_category)
      expect(master60).to_not include(rm_category)
      expect(master60).to_not include(usrm_category)
      expect(master60).to_not include(rmm_category)
      expect(master60).to include(cm60w_category)
    end

    it "can find return all eligbile categories by age class" do
      rcm_category
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category

      cadet_data = {age: 17, gender: "Male"}
      senior_data = {age: 21, gender: "Male"}
      master_data = {age: 50, gender: "Male"}

      cat_by_age_cadet = ArcherCategory.eligible_categories_by_age_class(cadet_data[:age], cadet_data[:gender])
      cat_by_age_senior = ArcherCategory.eligible_categories_by_age_class(senior_data[:age], senior_data[:gender])
      cat_by_age_master = ArcherCategory.eligible_categories_by_age_class(master_data[:age], master_data[:gender])

      expect(cat_by_age_cadet).to eq(["Cadet", "Junior", "Senior"])
      expect(cat_by_age_senior).to eq(["Senior"])
      expect(cat_by_age_master).to eq(["Senior", "Master"])
    end

    it "can find return all eligbile categories by category name" do
      rcm_category
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category

      cadet_data = {age: 17, gender: "Male"}
      senior_data = {age: 21, gender: "Male"}
      master_data = {age: 50, gender: "Male"}

      cat_by_name_cadet = ArcherCategory.eligible_categories_by_name(cadet_data[:age], cadet_data[:gender])
      cat_by_name_senior = ArcherCategory.eligible_categories_by_name(senior_data[:age], senior_data[:gender])
      cat_by_name_master = ArcherCategory.eligible_categories_by_name(master_data[:age], master_data[:gender])
      
      expect(cat_by_name_cadet).to eq(["Recurve-Cadet-Men", "Recurve-Junior-Men", "Recurve-Senior-Men"])
      expect(cat_by_name_senior).to eq(["Recurve-Senior-Men"])
      expect(cat_by_name_master).to eq(["Recurve-Senior-Men", "Recurve-Master-Men"])
    end
  end
end

