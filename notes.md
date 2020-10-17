# Archer Model
    - use ArcherCategory.default_by_archer_data to set default_cat attr via callback
        - requires an age calculation from Bday
        - since this will auto-update over time, need way to check if default_cat must also update upon login
        - need to allow this to be changed by user via profile, but can use the same method
            - default_by_selection

# Shot model
    # it "can identify all possible score values" do
    #   # max_score..score_areas, M, and X if x_ring
    # end

    # it "will only allows score values up to the number of score areas, M and X" do
    # end

    # it "won't allow allow a score value of X if there is no x-ring" do
    # end

# ArcherCategory Controller (will i even have a controller - don't want to think right now)
    - need to restrict so user can't update any items from this model
    - this will have to be part of ArcherCat controller tests
    
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


# Target Controller tests
    # let(:update_values) {
    #   {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3}
    # }
    # it "won't update a pre-loaded (non-user-editable) target" do
    #   pre_load_target.update(update_values)

    #   expect(pre_load_target.name).to eq("122cm/1-spot/10-ring")
    #   expect(pre_load_target.size).to eq("122cm")
    #   expect(pre_load_target.score_areas).to eq(10)
    #   expect(pre_load_target.rings).to eq(10)
    #   expect(pre_load_target.x_ring).to eq(true)
    #   expect(pre_load_target.max_score).to eq(10)
    #   expect(pre_load_target.spots).to eq(1)
    # end

# Misc Stuff To Do
    - when done - uncomment the USA in seeds and run that 
        - should be able to just run that to add an entirely new org to app