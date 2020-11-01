# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


# ##########################################################
# To re-use the db:seed task, use .find_or_create_by instead of .create. 
# However, should only use to populate DB when project created or adding new pre-load objects, such as when adding a new archery organization.
# To perform complex data seeding during the app lifecycle, create a new rake task, execute it then remove it.
# ##########################################################
# 1. Unless specified, include all attributes for model
# 2. Create each item individually (don't use iterations) - need each assigned to variable to make JOIN models easier to create

# ##########################################################
# Governning Bodies (pre-load)
# ##########################################################
    # add every organization
    # model = Organization::GovBody
    # all_attrs = (name: "World Archery", org_type: "International", geo_area: "Global")

    world_archery = Organization::GovBody.find_or_create_by(name: "World Archery", org_type: "International", geo_area: "Global")
    # usa_archery = Organization::GovBody.find_or_create_by(name: "USA Archery", org_type: "National", geo_area: "United States")


# ##########################################################
# Disciplines (pre-load)
# ##########################################################
    # add only unique disciplines
    # model = Organization::Discipline
    # all_attrs = (name: "Outdoor")

    outdoor = Organization::Discipline.find_or_create_by(name: "Outdoor")
    indoor = Organization::Discipline.find_or_create_by(name: "Indoor")


# ##########################################################
# Divisions (pre-load)
# ##########################################################
    # add only unique divisions
    # model = Organization::Division
    # all_attrs = (name: "Recurve")

    recurve = Organization::Division.find_or_create_by(name: "Recurve")
    compound = Organization::Division.find_or_create_by(name: "Compound")


# ##########################################################
# Age Classes (pre-load)
# ##########################################################
    # add all age classes (by governing body), duplicates won't be created - easier to assign to category this way
    # model = Organization::AgeClass
    # all_attrs = (name: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true)

    # World Archery
        wa_cadet = Organization::AgeClass.find_or_create_by(name: "Cadet", min_age: "", max_age: 17, open_to_younger: true, open_to_older: false)
        wa_junior = Organization::AgeClass.find_or_create_by(name: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false)
        wa_senior = Organization::AgeClass.find_or_create_by(name: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true)
        wa_master = Organization::AgeClass.find_or_create_by(name: "Master", min_age: 50, max_age: "", open_to_younger: false, open_to_older: true)

    # USA Archery (add when done)
        # us_bowman = Organization::AgeClass.find_or_create_by(name: "Bowman", min_age: "", max_age: 12, open_to_younger: true, open_to_older: false)
        # us_cub = Organization::AgeClass.find_or_create_by(name: "Cub", min_age: 13, max_age: 14, open_to_younger: true, open_to_older: false)
        # us_cadet = Organization::AgeClass.find_or_create_by(name: "Cadet", min_age: 15, max_age: 17, open_to_younger: true, open_to_older: false)
        # us_junior = Organization::AgeClass.find_or_create_by(name: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false)
        # us_senior = Organization::AgeClass.find_or_create_by(name: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true)
        # us_master50 = Organization::AgeClass.find_or_create_by(name: "Master", min_age: 50, max_age: 59, open_to_younger: false, open_to_older: true)
        # us_master60 = Organization::AgeClass.find_or_create_by(name: "Master", min_age: 60, max_age: 69, open_to_younger: false, open_to_older: true)
        # us_master70 = Organization::AgeClass.find_or_create_by(name: "Master", min_age: 70, max_age: "", open_to_younger: false, open_to_older: true)


# ##########################################################
# Genders (pre-load)
# ##########################################################
    # add only unique genders
    # model = Organization::Gender
    # all_attrs = (name: "Male")
    
    female = Organization::Gender.find_or_create_by(name: "Female")
    male = Organization::Gender.find_or_create_by(name: "Male")


# ##########################################################
# Categories (pre-load)
# ##########################################################
    # JOIN model/table - add all combinations of gov body, discipline, division, age class and gender (by gov body)
    # model = Organization::ArcherCategory
    # all_attrs = (cat_code: "WA-RCW", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_cadet, gender: female)

    # World Archery
        wa_rcw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RCW", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_cadet, gender: female)
        wa_rjw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RJW", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_junior, gender: female)
        wa_rsw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RW",  gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_senior, gender: female)
        wa_rmw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RMW", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_master, gender: female)
            
        wa_rcm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RCM", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_cadet, gender: male)
        wa_rjm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RJM", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_junior, gender: male)
        wa_rsm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RM",  gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_senior, gender: male)
        wa_rmm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-RMM", gov_body: world_archery, discipline: outdoor, division: recurve, age_class: wa_master, gender: male)
            
        wa_ccw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CCW", gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_cadet, gender: female)
        wa_cjw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CJW", gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_junior, gender: female)
        wa_csw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CW",  gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_senior, gender: female)
        wa_cmw = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CMW", gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_master, gender: female)

        wa_ccm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CCM", gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_cadet, gender: male)
        wa_cjm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CJM", gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_junior, gender: male)
        wa_csm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CM",  gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_senior, gender: male)
        wa_cmm = Organization::ArcherCategory.find_or_create_by(cat_code: "WA-CMM", gov_body: world_archery, discipline: outdoor, division: compound, age_class: wa_master, gender: male)

    # USA Archery (add when done)
        # usa_rbw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RBW", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_bowman, gender: female)
        # usa_ruw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RUW", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_cub, gender: female)
        # usa_rcw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RCW", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_cadet, gender: female)
        # usa_rjw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RJW", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_junior, gender: female)
        # usa_rsw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RW",  gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_senior, gender: female)
        # usa_rm50w = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM50W", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_master50, gender: female)
        # usa_rm60w = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM60W", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_master60, gender: female)
        # usa_rm70w = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM70W", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_master70, gender: female)
            
        # usa_rbm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RBW", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_bowman, gender: male)
        # usa_rum = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RUW", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_cub, gender: male)
        # usa_rcm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RCM", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_cadet, gender: male)
        # usa_rjm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RJM", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_junior, gender: male)
        # usa_rsm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM",  gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_senior, gender: male)
        # usa_rm50m = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM50M", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_master50, gender: male)
        # usa_rm60m = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM60M", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_master60, gender: male)
        # usa_rm70m = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-RM70M", gov_body: usa_archery, discipline: outdoor, division: recurve, age_class: us_master70, gender: male)

        # usa_cbw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CBW", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_bowman, gender: female)
        # usa_cuw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CUW", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_cub, gender: female)
        # usa_ccw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CCW", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_cadet, gender: female)
        # usa_cjw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CJW", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_junior, gender: female)
        # usa_csw = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CW",  gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_senior, ender: female)
        # usa_cm50w = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM50W", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_master50, gender: female)
        # usa_cm60w = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM60W", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_master60, gender: female)
        # usa_cm70w = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM70W", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_master70, gender: female)

        # usa_cbm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CBM", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_bowman, gender: male)
        # usa_cum = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CUM", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_cub, gender: male)
        # usa_ccm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CCM", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_cadet, gender: male)
        # usa_cjm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CJM", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_junior, gender: male)
        # usa_csm = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM",  gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_senior, ender: male)
        # usa_cm50m = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM50M", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_master50, gender: male)
        # usa_cm60m = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM60M", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_master60, gender: male)
        # usa_cm70m = Organization::ArcherCategory.find_or_create_by(cat_code: "USA-CM70M", gov_body: usa_archery, discipline: outdoor, division: compound, age_class: us_master70, gender: male)



# ###########################################################################################
# Round Formats (pre-load)
# ###########################################################################################
    # add only unique round formats (by governing body)
    # model = Format::RoundFormat
    # all_attrs = (name: "1440 Round", num_sets: 4, user_edit: false)
        # must set user_edit to false

    # World & USA Outdoor Rounds
        rf_db_1440 = Format::RoundFormat.find_or_create_by(name: "Double 1440 Round", num_sets: 8, user_edit: false)
        rf_1440 = Format::RoundFormat.find_or_create_by(name: "1440 Round", num_sets: 4, user_edit: false)
        rf_db_720 = Format::RoundFormat.find_or_create_by(name: "Double 720 Round", num_sets: 4, user_edit: false)
        rf_720 = Format::RoundFormat.find_or_create_by(name: "720 Round", num_sets: 2, user_edit: false)

    # World & USA Match Rounds (works for both Outdoor and Indoor)
        # need to sort out how to deal with this - indeterminanent # of Sets - also how to name the Sets
            # (probably best idea) Round has one set (how it is now) 
                # create new Round per ScoreSession for each bracket (need ability to do this anyway?)
                # for naming: pre-load a match round for each bracket, i.e. "1/32 Match Round"
                # then when entering Round score of "Win", automatically creates new round at next bracket
                # would need to add "Bye" as score option (also "DNF" ???)
        # rf_match = Format::RoundFormat.find_or_create_by(name: "Match Round", num_sets: 1, user_edit: false)

    # World & USA Indoor Rounds
        # rf_18m = Format::RoundFormat.find_or_create_by(name: "18m Round", num_sets: 2, user_edit: false)
        # rf_25m = Format::RoundFormat.find_or_create_by(name: "25m Round", num_sets: 2, user_edit: false)
        # rf_combo = Format::RoundFormat.find_or_create_by(name: "18m/25m Combined Round", num_sets: 2, user_edit: false)

    # Other Common Indoor Rounds (based on World)
        # rf_half_18m = Format::RoundFormat.find_or_create_by(name: "18m 300 Round", num_sets: 1, user_edit: false)



# ###########################################################################################
# Set/End Formats (pre-load - add only unique, but change name to match how/when used)
# ###########################################################################################
    # add all set formats (by round format), duplicates won't be created - easier to assign to DistanceTargetCategory lookup model this way
    # model = Format::SetEndFormat
    # all_attrs = (name: "Set/Distance1", num_ends: 6, shots_per_end: 6, user_edit: false, round_format_id: 1)
        # name auto-created (based on associated RoundFormat) - do not enter one when creating
        # must set user_edit to false
    # can't use .find_or_create_by because need duplicates, so add every new set into a conditional so old ones aren't duplicated

    # Sets for World & USA Outdoor Rounds
        if Format::SetEndFormat.count < 18      # should be the total number of Rsets to be created up to this point
            rdb1440_dist1 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist2 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist3 = Format::SetEndFormat.create(num_ends: 12, shots_per_end: 3, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist4 = Format::SetEndFormat.create(num_ends: 12, shots_per_end: 3, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist5 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist6 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist7 = Format::SetEndFormat.create(num_ends: 12, shots_per_end: 3, round_format: rf_db_1440, user_edit: false)
            rdb1440_dist8 = Format::SetEndFormat.create(num_ends: 12, shots_per_end: 3, round_format: rf_db_1440, user_edit: false)

            r1440_dist1 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_1440, user_edit: false)
            r1440_dist2 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_1440, user_edit: false)
            r1440_dist3 = Format::SetEndFormat.create(num_ends: 12, shots_per_end: 3, round_format: rf_1440, user_edit: false)
            r1440_dist4 = Format::SetEndFormat.create(num_ends: 12, shots_per_end: 3, round_format: rf_1440, user_edit: false)

            rdb720_dist1 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_720, user_edit: false)
            rdb720_dist2 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_720, user_edit: false)
            rdb720_dist3 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_720, user_edit: false)
            rdb720_dist4 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_db_720, user_edit: false)

            r720_dist1 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_720, user_edit: false)
            r720_dist2 = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, round_format: rf_720, user_edit: false)
        end

    # Sets for World & USA Match Rounds (works for both Outdoor and Indoor)
        # r_match_dist1 = Format::SetEndFormat.find_or_create_by(name: "Match Round- Set/Distance1", num_ends: 5, shots_per_end: 3, round_format: rf_match, user_edit: false)

    # Sets for World & USA Indoor Rounds
        # r18m_dist1 = Format::SetEndFormat.find_or_create_by(name: "18m - Set/Distance1", num_ends: 10, shots_per_end: 3, round_format: rf_18m, user_edit: false)
        # r18m_dist2 = Format::SetEndFormat.find_or_create_by(name: "18m - Set/Distance2", num_ends: 10, shots_per_end: 3, round_format: rf_18m, user_edit: false)

        # r25m_dist1 = Format::SetEndFormat.find_or_create_by(name: "25m - Set/Distance1", num_ends: 10, shots_per_end: 3, round_format: rf_25m, user_edit: false)
        # r25m_dist2 = Format::SetEndFormat.find_or_create_by(name: "25m - Set/Distance2", num_ends: 10, shots_per_end: 3, round_format: rf_25m, user_edit: false)

        # r1825c_dist1 = Format::SetEndFormat.find_or_create_by(name: "18/25 Combo - Set/Distance1", num_ends: 10, shots_per_end: 3, round_format: rf_combo, user_edit: false)
        # r1825c_dist2 = Format::SetEndFormat.find_or_create_by(name: "18/25 Combo - Set/Distance2", num_ends: 10, shots_per_end: 3, round_format: rf_combo, user_edit: false)

    # Sets for Other Common Indoor Rounds (based on World)
        # r_half_18m_dist1 = Format::SetEndFormat.find_or_create_by(name: "18m - Set/Distance1", num_ends: 10, shots_per_end: 3, round_format: rf_half_18m, user_edit: false)



# ##########################################################
# Targets (pre-load - add only unique targets)
# ##########################################################
    # add only unique targets (by governing body)
    # model = Format::Target
    # all_attrs = (name: "122cm/1-spot/10-ring", size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
        # name auto-created (based on input data) - do not enter one when creating
        # must set user_edit to false

    # both World Archery and USA Archery use these
        t122cm_1spot_10ring = Format::Target.find_or_create_by(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
        t80cm_1spot_10ring = Format::Target.find_or_create_by(size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
        t80cm_1spot_6ring = Format::Target.find_or_create_by(size: "80cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 1, user_edit: false)
        t60cm_1spot_10ring = Format::Target.find_or_create_by(size: "60cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
        t60cm_3spot_6ring = Format::Target.find_or_create_by(size: "60cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false)
        t40cm_1spot_10ring = Format::Target.find_or_create_by(size: "40cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
        t40cm_3spot_6ring = Format::Target.find_or_create_by(size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false)


# ##########################################################
# Distance/Target Lookup (pre-load - add all lookups)
# ##########################################################
    # JOIN model/table - add all combinations of 
    # model = Organization::DistanceTargetCategory
    # all_attrs = (set_end_format_id: 1, archer_category_id: 1, distance: "90m", target_id: 1, alt_target_id: 2)

    # Double 1440 Round
        wa_db1440_dtcs = {
        # Set/Distance 1 (122cm target (no alt), Men Jr/Sr shoot 90m, Men Cad/Mas & Women Jr/Sr shoot 70m, Women Cad/Mas shoot 60m)
            wa_db1440_dist1_rec_cad_w: {set_end_format: rdb1440_dist1, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_jr_w: {set_end_format: rdb1440_dist1, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_sr_w: {set_end_format: rdb1440_dist1, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_mas_w: {set_end_format: rdb1440_dist1, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_cad_m: {set_end_format: rdb1440_dist1, archer_category: wa_rcm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_jr_m: {set_end_format: rdb1440_dist1, archer_category: wa_rjm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_sr_m: {set_end_format: rdb1440_dist1, archer_category: wa_rsm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_rec_mas_m: {set_end_format: rdb1440_dist1, archer_category: wa_rmm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            
            wa_db1440_dist1_com_cad_w: {set_end_format: rdb1440_dist1, archer_category: wa_ccw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_jr_w: {set_end_format: rdb1440_dist1, archer_category: wa_cjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_sr_w: {set_end_format: rdb1440_dist1, archer_category: wa_csw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_mas_w: {set_end_format: rdb1440_dist1, archer_category: wa_cmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_cad_m: {set_end_format: rdb1440_dist1, archer_category: wa_ccm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_jr_m: {set_end_format: rdb1440_dist1, archer_category: wa_cjm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_sr_m: {set_end_format: rdb1440_dist1, archer_category: wa_csm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist1_com_mas_m: {set_end_format: rdb1440_dist1, archer_category: wa_cmm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 

        # Set/Distance 2 (same as set/dist 1 except: change number (var and sef), Men Jr/Sr shoot 70m, Men Cad/Mas & Women Jr/Sr shoot 60m, Women Cad/Mas shoot 50m)
            wa_db1440_dist2_rec_cad_w: {set_end_format: rdb1440_dist2, archer_category: wa_rcw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_jr_w: {set_end_format: rdb1440_dist2, archer_category: wa_rjw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_sr_w: {set_end_format: rdb1440_dist2, archer_category: wa_rsw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_mas_w: {set_end_format: rdb1440_dist2, archer_category: wa_rmw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_cad_m: {set_end_format: rdb1440_dist2, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_jr_m: {set_end_format: rdb1440_dist2, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_sr_m: {set_end_format: rdb1440_dist2, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_rec_mas_m: {set_end_format: rdb1440_dist2, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_db1440_dist2_com_cad_w: {set_end_format: rdb1440_dist2, archer_category: wa_ccw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_jr_w: {set_end_format: rdb1440_dist2, archer_category: wa_cjw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_sr_w: {set_end_format: rdb1440_dist2, archer_category: wa_csw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_mas_w: {set_end_format: rdb1440_dist2, archer_category: wa_cmw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_cad_m: {set_end_format: rdb1440_dist2, archer_category: wa_ccm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_jr_m: {set_end_format: rdb1440_dist2, archer_category: wa_cjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_sr_m: {set_end_format: rdb1440_dist2, archer_category: wa_csm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist2_com_mas_m: {set_end_format: rdb1440_dist2, archer_category: wa_cmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

        # Set/Distance 3 (same as set/dist 2 except: change number (var and sef), 80cm target (w/ alt), All Men & Women Jr/Sr shoot 50m, Women Cad/Mas shoot 40m))
            wa_db1440_dist3_rec_cad_w: {set_end_format: rdb1440_dist3, archer_category: wa_rcw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_jr_w: {set_end_format: rdb1440_dist3, archer_category: wa_rjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_sr_w: {set_end_format: rdb1440_dist3, archer_category: wa_rsw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_mas_w: {set_end_format: rdb1440_dist3, archer_category: wa_rmw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_cad_m: {set_end_format: rdb1440_dist3, archer_category: wa_rcm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_jr_m: {set_end_format: rdb1440_dist3, archer_category: wa_rjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_sr_m: {set_end_format: rdb1440_dist3, archer_category: wa_rsm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_rec_mas_m: {set_end_format: rdb1440_dist3, archer_category: wa_rmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

            wa_db1440_dist3_com_cad_w: {set_end_format: rdb1440_dist3, archer_category: wa_ccw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_jr_w: {set_end_format: rdb1440_dist3, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_sr_w: {set_end_format: rdb1440_dist3, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_mas_w: {set_end_format: rdb1440_dist3, archer_category: wa_cmw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_cad_m: {set_end_format: rdb1440_dist3, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_jr_m: {set_end_format: rdb1440_dist3, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_sr_m: {set_end_format: rdb1440_dist3, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist3_com_mas_m: {set_end_format: rdb1440_dist3, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 4 (same as set/dist 3 except: change number (var and sef), all shoot 30m)
            wa_db1440_dist4_rec_cad_w: {set_end_format: rdb1440_dist4, archer_category: wa_rcw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_jr_w: {set_end_format: rdb1440_dist4, archer_category: wa_rjw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_sr_w: {set_end_format: rdb1440_dist4, archer_category: wa_rsw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_mas_w: {set_end_format: rdb1440_dist4, archer_category: wa_rmw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_cad_m: {set_end_format: rdb1440_dist4, archer_category: wa_rcm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_jr_m: {set_end_format: rdb1440_dist4, archer_category: wa_rjm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_sr_m: {set_end_format: rdb1440_dist4, archer_category: wa_rsm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_rec_mas_m: {set_end_format: rdb1440_dist4, archer_category: wa_rmm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

            wa_db1440_dist4_com_cad_w: {set_end_format: rdb1440_dist4, archer_category: wa_ccw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_jr_w: {set_end_format: rdb1440_dist4, archer_category: wa_cjw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_sr_w: {set_end_format: rdb1440_dist4, archer_category: wa_csw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_mas_w: {set_end_format: rdb1440_dist4, archer_category: wa_cmw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_cad_m: {set_end_format: rdb1440_dist4, archer_category: wa_ccm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_jr_m: {set_end_format: rdb1440_dist4, archer_category: wa_cjm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_sr_m: {set_end_format: rdb1440_dist4, archer_category: wa_csm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist4_com_mas_m: {set_end_format: rdb1440_dist4, archer_category: wa_cmm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 5 (repeat set/dist 1, change number (var and sef))
            wa_db1440_dist5_rec_cad_w: {set_end_format: rdb1440_dist5, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_jr_w: {set_end_format: rdb1440_dist5, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_sr_w: {set_end_format: rdb1440_dist5, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_mas_w: {set_end_format: rdb1440_dist5, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_cad_m: {set_end_format: rdb1440_dist5, archer_category: wa_rcm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_jr_m: {set_end_format: rdb1440_dist5, archer_category: wa_rjm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_sr_m: {set_end_format: rdb1440_dist5, archer_category: wa_rsm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_rec_mas_m: {set_end_format: rdb1440_dist5, archer_category: wa_rmm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            
            wa_db1440_dist5_com_cad_w: {set_end_format: rdb1440_dist5, archer_category: wa_ccw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_jr_w: {set_end_format: rdb1440_dist5, archer_category: wa_cjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_sr_w: {set_end_format: rdb1440_dist5, archer_category: wa_csw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_mas_w: {set_end_format: rdb1440_dist5, archer_category: wa_cmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_cad_m: {set_end_format: rdb1440_dist5, archer_category: wa_ccm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_jr_m: {set_end_format: rdb1440_dist5, archer_category: wa_cjm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_sr_m: {set_end_format: rdb1440_dist5, archer_category: wa_csm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist5_com_mas_m: {set_end_format: rdb1440_dist5, archer_category: wa_cmm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 

        # Set/Distance 6 (repeat set/dist 2, change number (var and sef))
            wa_db1440_dist6_rec_cad_w: {set_end_format: rdb1440_dist6, archer_category: wa_rcw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_jr_w: {set_end_format: rdb1440_dist6, archer_category: wa_rjw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_sr_w: {set_end_format: rdb1440_dist6, archer_category: wa_rsw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_mas_w: {set_end_format: rdb1440_dist6, archer_category: wa_rmw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_cad_m: {set_end_format: rdb1440_dist6, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_jr_m: {set_end_format: rdb1440_dist6, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_sr_m: {set_end_format: rdb1440_dist6, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_rec_mas_m: {set_end_format: rdb1440_dist6, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_db1440_dist6_com_cad_w: {set_end_format: rdb1440_dist6, archer_category: wa_ccw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_jr_w: {set_end_format: rdb1440_dist6, archer_category: wa_cjw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_sr_w: {set_end_format: rdb1440_dist6, archer_category: wa_csw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_mas_w: {set_end_format: rdb1440_dist6, archer_category: wa_cmw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_cad_m: {set_end_format: rdb1440_dist6, archer_category: wa_ccm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_jr_m: {set_end_format: rdb1440_dist6, archer_category: wa_cjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_sr_m: {set_end_format: rdb1440_dist6, archer_category: wa_csm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db1440_dist6_com_mas_m: {set_end_format: rdb1440_dist6, archer_category: wa_cmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

        # Set/Distance 7 (repeat set/dist 3, change number (var and sef))
            wa_db1440_dist7_rec_cad_w: {set_end_format: rdb1440_dist7, archer_category: wa_rcw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_jr_w: {set_end_format: rdb1440_dist7, archer_category: wa_rjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_sr_w: {set_end_format: rdb1440_dist7, archer_category: wa_rsw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_mas_w: {set_end_format: rdb1440_dist7, archer_category: wa_rmw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_cad_m: {set_end_format: rdb1440_dist7, archer_category: wa_rcm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_jr_m: {set_end_format: rdb1440_dist7, archer_category: wa_rjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_sr_m: {set_end_format: rdb1440_dist7, archer_category: wa_rsm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_rec_mas_m: {set_end_format: rdb1440_dist7, archer_category: wa_rmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

            wa_db1440_dist7_com_cad_w: {set_end_format: rdb1440_dist7, archer_category: wa_ccw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_jr_w: {set_end_format: rdb1440_dist7, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_sr_w: {set_end_format: rdb1440_dist7, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_mas_w: {set_end_format: rdb1440_dist7, archer_category: wa_cmw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_cad_m: {set_end_format: rdb1440_dist7, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_jr_m: {set_end_format: rdb1440_dist7, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_sr_m: {set_end_format: rdb1440_dist7, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist7_com_mas_m: {set_end_format: rdb1440_dist7, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 8 (repeat set/dist 4, change number (var and sef))
            wa_db1440_dist8_rec_cad_w: {set_end_format: rdb1440_dist8, archer_category: wa_rcw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_jr_w: {set_end_format: rdb1440_dist8, archer_category: wa_rjw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_sr_w: {set_end_format: rdb1440_dist8, archer_category: wa_rsw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_mas_w: {set_end_format: rdb1440_dist8, archer_category: wa_rmw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_cad_m: {set_end_format: rdb1440_dist8, archer_category: wa_rcm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_jr_m: {set_end_format: rdb1440_dist8, archer_category: wa_rjm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_sr_m: {set_end_format: rdb1440_dist8, archer_category: wa_rsm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_rec_mas_m: {set_end_format: rdb1440_dist8, archer_category: wa_rmm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

            wa_db1440_dist8_com_cad_w: {set_end_format: rdb1440_dist8, archer_category: wa_ccw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_jr_w: {set_end_format: rdb1440_dist8, archer_category: wa_cjw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_sr_w: {set_end_format: rdb1440_dist8, archer_category: wa_csw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_mas_w: {set_end_format: rdb1440_dist8, archer_category: wa_cmw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_cad_m: {set_end_format: rdb1440_dist8, archer_category: wa_ccm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_jr_m: {set_end_format: rdb1440_dist8, archer_category: wa_cjm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_sr_m: {set_end_format: rdb1440_dist8, archer_category: wa_csm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db1440_dist8_com_mas_m: {set_end_format: rdb1440_dist8, archer_category: wa_cmm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}
        }
        wa_db1440_dtcs.each do |dtc, attrs|
            Organization::DistanceTargetCategory.find_or_create_by(attrs)
        end

    # 1440 Round
        wa_1440_dtcs = {
        # Set/Distance 1 (repeat Double 1440 set/dist 1, change round (var and sef))
            wa_1440_dist1_rec_cad_w: {set_end_format: r1440_dist1, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_jr_w: {set_end_format: r1440_dist1, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_sr_w: {set_end_format: r1440_dist1, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_mas_w: {set_end_format: r1440_dist1, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_cad_m: {set_end_format: r1440_dist1, archer_category: wa_rcm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_jr_m: {set_end_format: r1440_dist1, archer_category: wa_rjm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_sr_m: {set_end_format: r1440_dist1, archer_category: wa_rsm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_rec_mas_m: {set_end_format: r1440_dist1, archer_category: wa_rmm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            
            wa_1440_dist1_com_cad_w: {set_end_format: r1440_dist1, archer_category: wa_ccw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_jr_w: {set_end_format: r1440_dist1, archer_category: wa_cjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_sr_w: {set_end_format: r1440_dist1, archer_category: wa_csw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_mas_w: {set_end_format: r1440_dist1, archer_category: wa_cmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_cad_m: {set_end_format: r1440_dist1, archer_category: wa_ccm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_jr_m: {set_end_format: r1440_dist1, archer_category: wa_cjm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_sr_m: {set_end_format: r1440_dist1, archer_category: wa_csm, distance: "90m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist1_com_mas_m: {set_end_format: r1440_dist1, archer_category: wa_cmm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 

        # Set/Distance 2 (repeat Double 1440 set/dist 2, change round (var and sef))
            wa_1440_dist2_rec_cad_w: {set_end_format: r1440_dist2, archer_category: wa_rcw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_jr_w: {set_end_format: r1440_dist2, archer_category: wa_rjw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_sr_w: {set_end_format: r1440_dist2, archer_category: wa_rsw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_mas_w: {set_end_format: r1440_dist2, archer_category: wa_rmw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_cad_m: {set_end_format: r1440_dist2, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_jr_m: {set_end_format: r1440_dist2, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_sr_m: {set_end_format: r1440_dist2, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_rec_mas_m: {set_end_format: r1440_dist2, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_1440_dist2_com_cad_w: {set_end_format: r1440_dist2, archer_category: wa_ccw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_jr_w: {set_end_format: r1440_dist2, archer_category: wa_cjw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_sr_w: {set_end_format: r1440_dist2, archer_category: wa_csw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_mas_w: {set_end_format: r1440_dist2, archer_category: wa_cmw, distance: "50m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_cad_m: {set_end_format: r1440_dist2, archer_category: wa_ccm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_jr_m: {set_end_format: r1440_dist2, archer_category: wa_cjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_sr_m: {set_end_format: r1440_dist2, archer_category: wa_csm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_1440_dist2_com_mas_m: {set_end_format: r1440_dist2, archer_category: wa_cmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

        # Set/Distance 3 (repeat Double 1440 set/dist 3, change round (var and sef))
            wa_1440_dist3_rec_cad_w: {set_end_format: r1440_dist3, archer_category: wa_rcw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_jr_w: {set_end_format: r1440_dist3, archer_category: wa_rjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_sr_w: {set_end_format: r1440_dist3, archer_category: wa_rsw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_mas_w: {set_end_format: r1440_dist3, archer_category: wa_rmw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_cad_m: {set_end_format: r1440_dist3, archer_category: wa_rcm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_jr_m: {set_end_format: r1440_dist3, archer_category: wa_rjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_sr_m: {set_end_format: r1440_dist3, archer_category: wa_rsm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_rec_mas_m: {set_end_format: r1440_dist3, archer_category: wa_rmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

            wa_1440_dist3_com_cad_w: {set_end_format: r1440_dist3, archer_category: wa_ccw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_jr_w: {set_end_format: r1440_dist3, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_sr_w: {set_end_format: r1440_dist3, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_mas_w: {set_end_format: r1440_dist3, archer_category: wa_cmw, distance: "40m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_cad_m: {set_end_format: r1440_dist3, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_jr_m: {set_end_format: r1440_dist3, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_sr_m: {set_end_format: r1440_dist3, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist3_com_mas_m: {set_end_format: r1440_dist3, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 4 (repeat Double 1440 set/dist 4, change round (var and sef))
            wa_1440_dist4_rec_cad_w: {set_end_format: r1440_dist4, archer_category: wa_rcw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_jr_w: {set_end_format: r1440_dist4, archer_category: wa_rjw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_sr_w: {set_end_format: r1440_dist4, archer_category: wa_rsw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_mas_w: {set_end_format: r1440_dist4, archer_category: wa_rmw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_cad_m: {set_end_format: r1440_dist4, archer_category: wa_rcm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_jr_m: {set_end_format: r1440_dist4, archer_category: wa_rjm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_sr_m: {set_end_format: r1440_dist4, archer_category: wa_rsm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_rec_mas_m: {set_end_format: r1440_dist4, archer_category: wa_rmm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

            wa_1440_dist4_com_cad_w: {set_end_format: r1440_dist4, archer_category: wa_ccw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_jr_w: {set_end_format: r1440_dist4, archer_category: wa_cjw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_sr_w: {set_end_format: r1440_dist4, archer_category: wa_csw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_mas_w: {set_end_format: r1440_dist4, archer_category: wa_cmw, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_cad_m: {set_end_format: r1440_dist4, archer_category: wa_ccm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_jr_m: {set_end_format: r1440_dist4, archer_category: wa_cjm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_sr_m: {set_end_format: r1440_dist4, archer_category: wa_csm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_1440_dist4_com_mas_m: {set_end_format: r1440_dist4, archer_category: wa_cmm, distance: "30m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}
        }
        wa_1440_dtcs.each do |dtc, attrs|
            Organization::DistanceTargetCategory.find_or_create_by(attrs)
        end

    # Double 720 Round
        wa_db720_dtcs = {
        # Set/Distance 1 (repeat 1440 set/dist 2, change round (var and sef), Recurve: Men Jr/Sr & Women Jr/Sr shoot 70m, Men Cad/Mas & Women Cad/Mas shoot 60m, Compound: all shoot 50m, 80cm target (w/alt))
            wa_db720_dist1_rec_cad_w: {set_end_format: rdb720_dist1, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_jr_w: {set_end_format: rdb720_dist1, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_sr_w: {set_end_format: rdb720_dist1, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_mas_w: {set_end_format: rdb720_dist1, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_cad_m: {set_end_format: rdb720_dist1, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_jr_m: {set_end_format: rdb720_dist1, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_sr_m: {set_end_format: rdb720_dist1, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist1_rec_mas_m: {set_end_format: rdb720_dist1, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_db720_dist1_com_cad_w: {set_end_format: rdb720_dist1, archer_category: wa_ccw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_jr_w: {set_end_format: rdb720_dist1, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_sr_w: {set_end_format: rdb720_dist1, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_mas_w: {set_end_format: rdb720_dist1, archer_category: wa_cmw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_cad_m: {set_end_format: rdb720_dist1, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_jr_m: {set_end_format: rdb720_dist1, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_sr_m: {set_end_format: rdb720_dist1, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist1_com_mas_m: {set_end_format: rdb720_dist1, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 2 (repeat Double 720 set/dist 1, change number (var and sef))
            wa_db720_dist2_rec_cad_w: {set_end_format: rdb720_dist2, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_jr_w: {set_end_format: rdb720_dist2, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_sr_w: {set_end_format: rdb720_dist2, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_mas_w: {set_end_format: rdb720_dist2, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_cad_m: {set_end_format: rdb720_dist2, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_jr_m: {set_end_format: rdb720_dist2, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_sr_m: {set_end_format: rdb720_dist2, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist2_rec_mas_m: {set_end_format: rdb720_dist2, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_db720_dist2_com_cad_w: {set_end_format: rdb720_dist2, archer_category: wa_ccw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_jr_w: {set_end_format: rdb720_dist2, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_sr_w: {set_end_format: rdb720_dist2, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_mas_w: {set_end_format: rdb720_dist2, archer_category: wa_cmw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_cad_m: {set_end_format: rdb720_dist2, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_jr_m: {set_end_format: rdb720_dist2, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_sr_m: {set_end_format: rdb720_dist2, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist2_com_mas_m: {set_end_format: rdb720_dist2, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 3 (repeat Double 720 set/dist 1, change number (var and sef))
            wa_db720_dist3_rec_cad_w: {set_end_format: rdb720_dist3, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_jr_w: {set_end_format: rdb720_dist3, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_sr_w: {set_end_format: rdb720_dist3, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_mas_w: {set_end_format: rdb720_dist3, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_cad_m: {set_end_format: rdb720_dist3, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_jr_m: {set_end_format: rdb720_dist3, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_sr_m: {set_end_format: rdb720_dist3, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist3_rec_mas_m: {set_end_format: rdb720_dist3, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_db720_dist3_com_cad_w: {set_end_format: rdb720_dist3, archer_category: wa_ccw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_jr_w: {set_end_format: rdb720_dist3, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_sr_w: {set_end_format: rdb720_dist3, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_mas_w: {set_end_format: rdb720_dist3, archer_category: wa_cmw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_cad_m: {set_end_format: rdb720_dist3, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_jr_m: {set_end_format: rdb720_dist3, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_sr_m: {set_end_format: rdb720_dist3, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist3_com_mas_m: {set_end_format: rdb720_dist3, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 4 (repeat Double 720 set/dist 1, change number (var and sef))
            wa_db720_dist4_rec_cad_w: {set_end_format: rdb720_dist4, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_jr_w: {set_end_format: rdb720_dist4, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_sr_w: {set_end_format: rdb720_dist4, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_mas_w: {set_end_format: rdb720_dist4, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_cad_m: {set_end_format: rdb720_dist4, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_jr_m: {set_end_format: rdb720_dist4, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_sr_m: {set_end_format: rdb720_dist4, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_db720_dist4_rec_mas_m: {set_end_format: rdb720_dist4, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_db720_dist4_com_cad_w: {set_end_format: rdb720_dist4, archer_category: wa_ccw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_jr_w: {set_end_format: rdb720_dist4, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_sr_w: {set_end_format: rdb720_dist4, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_mas_w: {set_end_format: rdb720_dist4, archer_category: wa_cmw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_cad_m: {set_end_format: rdb720_dist4, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_jr_m: {set_end_format: rdb720_dist4, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_sr_m: {set_end_format: rdb720_dist4, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_db720_dist4_com_mas_m: {set_end_format: rdb720_dist4, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}
        }
        wa_db720_dtcs.each do |dtc, attrs|
            Organization::DistanceTargetCategory.find_or_create_by(attrs)
        end

    # 720 Round
        wa_720_dtcs = {
        # Set/Distance 1 (repeat Double 720 set/dist 1, change round (var and sef))
            wa_720_dist1_rec_cad_w: {set_end_format: r720_dist1, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_jr_w: {set_end_format: r720_dist1, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_sr_w: {set_end_format: r720_dist1, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_mas_w: {set_end_format: r720_dist1, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_cad_m: {set_end_format: r720_dist1, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_jr_m: {set_end_format: r720_dist1, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_sr_m: {set_end_format: r720_dist1, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist1_rec_mas_m: {set_end_format: r720_dist1, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_720_dist1_com_cad_w: {set_end_format: r720_dist1, archer_category: wa_ccw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_jr_w: {set_end_format: r720_dist1, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_sr_w: {set_end_format: r720_dist1, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_mas_w: {set_end_format: r720_dist1, archer_category: wa_cmw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_cad_m: {set_end_format: r720_dist1, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_jr_m: {set_end_format: r720_dist1, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_sr_m: {set_end_format: r720_dist1, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist1_com_mas_m: {set_end_format: r720_dist1, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 

        # Set/Distance 2 (repeat Double 720 set/dist 2, change round (var and sef))
            wa_720_dist2_rec_cad_w: {set_end_format: r720_dist2, archer_category: wa_rcw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_jr_w: {set_end_format: r720_dist2, archer_category: wa_rjw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_sr_w: {set_end_format: r720_dist2, archer_category: wa_rsw, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_mas_w: {set_end_format: r720_dist2, archer_category: wa_rmw, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_cad_m: {set_end_format: r720_dist2, archer_category: wa_rcm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_jr_m: {set_end_format: r720_dist2, archer_category: wa_rjm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_sr_m: {set_end_format: r720_dist2, archer_category: wa_rsm, distance: "70m", target: t122cm_1spot_10ring, alt_target: nil}, 
            wa_720_dist2_rec_mas_m: {set_end_format: r720_dist2, archer_category: wa_rmm, distance: "60m", target: t122cm_1spot_10ring, alt_target: nil}, 

            wa_720_dist2_com_cad_w: {set_end_format: r720_dist2, archer_category: wa_ccw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_jr_w: {set_end_format: r720_dist2, archer_category: wa_cjw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_sr_w: {set_end_format: r720_dist2, archer_category: wa_csw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_mas_w: {set_end_format: r720_dist2, archer_category: wa_cmw, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_cad_m: {set_end_format: r720_dist2, archer_category: wa_ccm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_jr_m: {set_end_format: r720_dist2, archer_category: wa_cjm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_sr_m: {set_end_format: r720_dist2, archer_category: wa_csm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}, 
            wa_720_dist2_com_mas_m: {set_end_format: r720_dist2, archer_category: wa_cmm, distance: "50m", target: t80cm_1spot_10ring, alt_target: t80cm_1spot_6ring}
        }
        wa_720_dtcs.each do |dtc, attrs|
            Organization::DistanceTargetCategory.find_or_create_by(attrs)
        end


# ##########################################################
# NFAA (preliminary info)
# ##########################################################
    # NFAA (add later)

    # nfaa_target_attrs = {
    #     cm65_1spot_5ring: {size: "65cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
    #     cm50_1spot_5ring: {size: "50cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
    #     cm35_1spot_5ring: {size: "35cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
    #     cm20_1spot_5ring: {size: "20cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
    #     cm40_1spot_5ring: {size: "40cm", score_areas: 5, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
    #     cm40_5spot_3ring: {size: "40cm", score_areas: 2, rings: 3, x_ring: true, max_score: 5, spots: 5, user_edit: false}
    # }



# ##########################################################
# 3D Targets (pre-load)
# ##########################################################
    # 3D targets (add later)

