require 'rails_helper'

RSpec.describe RoundSet, type: :model do
  let(:pre_load_target) {
    Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
  }

  let(:user_target) {
    Target.create(size: "20in", score_areas: 2, rings: 4, x_ring: true, max_score: 5, spots: 5)
  }

  let(:rm_category) {
    ArcherCategory.create(cat_code: "RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: nil, max_age: nil, cat_gender: "Male")
  }
  
  # need to create a Set to associate
  # let(:pre_load_set) {
  #   Set.create()
  # }

  let(:dist_targ) {
    DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, set_id: 1)
  }

  let(:update_values) {
    {}
  }
  
  let(:no_name) {
    {}
  }

  let(:duplicate) {
    {}
  }

  # object creation and validation tests #######################################
  describe "model creates and updates valid instances:" do
  end

  # association tests ########################################################
  describe "all helper methods work correctly:" do
  end

end
