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

  let(:pre_load_set) {
    Set.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
  }

  let(:dist_targ_cat) {
    DistanceTargetCategory.create(distance: "90m", target_id: 1, archer_category_id: 1, set_id: 1)
  }

  let(:duplicate) {
    {cat_code: "WA-RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}
  }

  let(:blank) {
    {cat_code: "", gov_body: "", cat_division: "", cat_age_class: "", min_age: "", max_age: "", open_to_younger: "", open_to_older: "", cat_gender: ""}
  }

  let(:bad_inclusion) {
    {cat_code: "WA-RM", gov_body: "bad data", cat_division: "bad data", cat_age_class: "bad data", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "bad data"}
  }

  let(:default_missing_message) {"can't be blank"}
  let(:default_duplicate_message) {"has already been taken"}
  let(:default_inclusion_message) {"is not included in the list"}
  
  # object creation and validation tests #######################################
  describe "model creates and updates only valid instances" do
    describe "valid with all required and unrequired input data" do
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
    end

    describe "invalid if input data is missing or bad" do
      it "is invalid without required attributes and has correct error message" do
        category = ArcherCategory.create(blank)

        expect(category).to be_invalid
        expect(category.errors.messages[:cat_code]).to include(default_missing_message)
        expect(category.errors.messages[:gov_body]).to include(default_missing_message)
        expect(category.errors.messages[:cat_division]).to include(default_missing_message)
        expect(category.errors.messages[:cat_age_class]).to include(default_missing_message)
        expect(category.errors.messages[:cat_gender]).to include(default_missing_message)
      end

      it "is invalid when unique attributes are duplicated and has correct error message" do
        rm_category
        category = ArcherCategory.create(duplicate)

        expect(category).to be_invalid
        expect(category.errors.messages[:cat_code]).to include(default_duplicate_message)
      end

      it "is invalid if value not included in corresponding selection list and has correct error message" do
        category = ArcherCategory.create(bad_inclusion)

        expect(category).to be_invalid
        expect(category.errors.messages[:gov_body]).to include(default_inclusion_message)
        expect(category.errors.messages[:cat_division]).to include(default_inclusion_message)
        expect(category.errors.messages[:cat_age_class]).to include(default_inclusion_message)
        expect(category.errors.messages[:cat_gender]).to include(default_inclusion_message)
      end
    end
  end

  # association tests ########################################################
  describe "instances are properly associated to other models" do
    before(:each) do
      pre_load_set
      pre_load_target
      rm_category
      dist_targ_cat
    end

    it "has many Sets" do
      expect(rm_category.sets).to include(pre_load_set)
    end

    it "has many Targets" do
      expect(rm_category.targets).to include(pre_load_target)
    end
  end
  
  # helper method tests ########################################################
  describe "all helper methods work correctly:" do
    before(:each) do
      rcm_category
      rjm_category
      rm_category
      usrm_category
      rmm_category
      cm60w_category
    end

    it "has a user-friendly display name" do
      expect(rm_category.name).to eq("Recurve-Senior-Men")
    end

    describe "can calculate default categories with Archer data" do
      it "for cadet" do
        cadet_data = {division: "Recurve", age: 17, gender: "Male"}
        cadet = ArcherCategory.default(cadet_data[:division], cadet_data[:age], cadet_data[:gender])

        expect(cadet).to include(rcm_category)
        expect(cadet).to_not include(rjm_category)
        expect(cadet).to_not include(rm_category)
        expect(cadet).to_not include(usrm_category)
        expect(cadet).to_not include(rmm_category)
        expect(cadet).to_not include(cm60w_category)
      end

      it "for junior" do
        junior_data = {division: "Recurve", age: 20, gender: "Male"}
        junior = ArcherCategory.default(junior_data[:division], junior_data[:age], junior_data[:gender])

        expect(junior).to_not include(rcm_category)
        expect(junior).to include(rjm_category)
        expect(junior).to_not include(rm_category)
        expect(junior).to_not include(usrm_category)
        expect(junior).to_not include(rmm_category)
        expect(junior).to_not include(cm60w_category)
      end

      it "for senior" do
        senior_data = {division: "Recurve", age: 21, gender: "Male"}
        senior_data_two = {division: "Recurve", age: 49, gender: "Male"}
        senior = ArcherCategory.default(senior_data[:division], senior_data[:age], senior_data[:gender])
        senior_two = ArcherCategory.default(senior_data_two[:division], senior_data_two[:age], senior_data_two[:gender])
        
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
      end

      it "for master" do
        master_data = {division: "Recurve", age: 50, gender: "Male"}
        master = ArcherCategory.default(master_data[:division], master_data[:age], master_data[:gender])

        expect(master).to_not include(rcm_category)
        expect(master).to_not include(rjm_category)
        expect(master).to_not include(rm_category)
        expect(master).to_not include(usrm_category)
        expect(master).to include(rmm_category)
        expect(master).to_not include(cm60w_category)
      end

      it "for master60" do
        master60_data = {division: "Compound", age: 60, gender: "Female"}
        master60 = ArcherCategory.default(master60_data[:division], master60_data[:age], master60_data[:gender])

        expect(master60).to_not include(rcm_category)
        expect(master60).to_not include(rjm_category)
        expect(master60).to_not include(rm_category)
        expect(master60).to_not include(usrm_category)
        expect(master60).to_not include(rmm_category)
        expect(master60).to include(cm60w_category)
      end
    end

    describe "can find all eligbile categories by Archer age and gender" do

      it "for cadet" do
        cadet_data = {age: 17, gender: "Male"}
        cadet = ArcherCategory.eligible_categories(cadet_data[:age], cadet_data[:gender])

        expect(cadet).to include(rcm_category)
        expect(cadet).to include(rjm_category)
        expect(cadet).to include(rm_category)
        expect(cadet).to include(usrm_category)
        expect(cadet).to_not include(rmm_category)
        expect(cadet).to_not include(cm60w_category)
      end

      it "for junior" do
        junior_data = {age: 19, gender: "Male"}
        junior = ArcherCategory.eligible_categories(junior_data[:age], junior_data[:gender])

        expect(junior).to_not include(rcm_category)
        expect(junior).to include(rjm_category)
        expect(junior).to include(rm_category)
        expect(junior).to include(usrm_category)
        expect(junior).to_not include(rmm_category)
        expect(junior).to_not include(cm60w_category)
      end

      it "for senior" do
        senior_data = {age: 21, gender: "Male"}
        senior_data_two = {age: 49, gender: "Male"}
        senior = ArcherCategory.eligible_categories(senior_data[:age], senior_data[:gender])
        senior_two = ArcherCategory.eligible_categories(senior_data_two[:age], senior_data_two[:gender])

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
      end

      it "for master" do
        master_data = {age: 50, gender: "Male"}
        master = ArcherCategory.eligible_categories(master_data[:age], master_data[:gender])

        expect(master).to_not include(rcm_category)
        expect(master).to_not include(rjm_category)
        expect(master).to include(rm_category)
        expect(master).to include(usrm_category)
        expect(master).to include(rmm_category)
        expect(master).to_not include(cm60w_category)
      end

      it "for master60" do
        master60_data = {age: 60, gender: "Female"}
        master60 = ArcherCategory.eligible_categories(master60_data[:age], master60_data[:gender])

        expect(master60).to_not include(rcm_category)
        expect(master60).to_not include(rjm_category)
        expect(master60).to_not include(rm_category)
        expect(master60).to_not include(usrm_category)
        expect(master60).to_not include(rmm_category)
        expect(master60).to include(cm60w_category)
      end
    end

    describe "can return all eligbile categories" do
      it "by age class" do
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

      it "by category name" do
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
end

