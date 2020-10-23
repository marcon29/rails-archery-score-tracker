# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


# ##########################################################
# To re-use the db:seed task, use .find_or_create_by instead of .create. 
# However, should only use to populate DB when project created or adding new pre-load objects, such as when adding a new archery organization.
# To perform complex data seeding during the app lifecycle, create a new rake task, execute it then remove it.
# ##########################################################


# ##########################################################
# World Archery Targets and Categories (pre-load)
# ##########################################################

# #### Targets ####
wa_target_attrs = {
    cm122_1spot_10ring: {size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm80_1spot_10ring: {size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm80_1spot_6ring: {size: "80cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm60_1spot_10ring: {size: "60cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm60_3spot_6ring: {size: "60cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false}, 
    cm40_1spot_10ring: {size: "40cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm40_3spot_6ring: {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false}
}

# #### Categories ####
wa_category_attrs = {
    wa_rcw: {cat_code: "WA-RCW", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Cadet", min_age: "", max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    wa_rjw: {cat_code: "WA-RJW", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    wa_rsw: {cat_code: "WA-RW",  gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Female"}, 
    wa_rmw: {cat_code: "WA-RMW", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 50, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 
    
    wa_rcm: {cat_code: "WA-RCM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Cadet", min_age: "", max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    wa_rjm: {cat_code: "WA-RJM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    wa_rsm: {cat_code: "WA-RM",  gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}, 
    wa_rmm: {cat_code: "WA-RMM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 50, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Male"}, 
    
    wa_ccw: {cat_code: "WA-CCW", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Cadet", min_age: "", max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    wa_cjw: {cat_code: "WA-CJW", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    wa_csw: {cat_code: "WA-CW",  gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Female"}, 
    wa_cmw: {cat_code: "WA-CMW", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 50, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 

    wa_ccm: {cat_code: "WA-CCM", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Cadet", min_age: "", max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    wa_cjm: {cat_code: "WA-CJM", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    wa_csm: {cat_code: "WA-CM",  gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}, 
    wa_cmm: {cat_code: "WA-CMM", gov_body: "World Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 50, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Male"}
}

# #### Standard Rsets ####
wa_set_attrs = {
    wa1440_dist1: {name: "1440 Round - Rset/Distance1", ends: 6,  shots_per_end: 6, score_method: "Points"}, 
    wa1440_dist2: {name: "1440 Round - Rset/Distance2", ends: 6,  shots_per_end: 6, score_method: "Points"}, 
    wa1440_dist3: {name: "1440 Round - Rset/Distance3", ends: 12, shots_per_end: 3, score_method: "Points"}, 
    wa1440_dist4: {name: "1440 Round - Rset/Distance4", ends: 12, shots_per_end: 3, score_method: "Points"}, 
    wa720_dist1:  {name: "720 Round - Rset/Distance1", ends: 6, shots_per_end: 6, score_method: "Points"}, 
    wa_match_dist1:  {name: "Match Round - Rset/Distance1", ends: 5, shots_per_end: 3, score_method: "Set"}
}

# #### Distance/Target Lookup ####
wa1440_attrs = {
    wa1440_dist1_cadet_m:  {rset_id: 1, age_class: "Cadet",  gender: "Male",   distance: "70m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_cadet_w:  {rset_id: 1, age_class: "Cadet",  gender: "Female", distance: "60m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_junior_m: {rset_id: 1, age_class: "Junior", gender: "Male",   distance: "90m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_junior_w: {rset_id: 1, age_class: "Junior", gender: "Female", distance: "70m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_senior_m: {rset_id: 1, age_class: "Senior", gender: "Male",   distance: "90m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_senior_w: {rset_id: 1, age_class: "Senior", gender: "Female", distance: "70m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_master_m: {rset_id: 1, age_class: "Master", gender: "Male",   distance: "70m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist1_master_w: {rset_id: 1, age_class: "Master", gender: "Female", distance: "60m", target_name: "122cm/1-spot/10-ring"}, 

    wa1440_dist2_cadet_m:  {rset_id: 2, age_class: "Cadet",  gender: "Male",   distance: "60m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_cadet_w:  {rset_id: 2, age_class: "Cadet",  gender: "Female", distance: "50m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_junior_m: {rset_id: 2, age_class: "Junior", gender: "Male",   distance: "70m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_junior_w: {rset_id: 2, age_class: "Junior", gender: "Female", distance: "60m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_senior_m: {rset_id: 2, age_class: "Senior", gender: "Male",   distance: "70m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_senior_w: {rset_id: 2, age_class: "Senior", gender: "Female", distance: "60m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_master_m: {rset_id: 2, age_class: "Master", gender: "Male",   distance: "60m", target_name: "122cm/1-spot/10-ring"}, 
    wa1440_dist2_master_w: {rset_id: 2, age_class: "Master", gender: "Female", distance: "50m", target_name: "122cm/1-spot/10-ring"}, 

    wa1440_dist3_cadet_m:  {rset_id: 3, age_class: "Cadet",  gender: "Male",   distance: "50m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_cadet_w:  {rset_id: 3, age_class: "Cadet",  gender: "Female", distance: "40m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_junior_m: {rset_id: 3, age_class: "Junior", gender: "Male",   distance: "50m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_junior_w: {rset_id: 3, age_class: "Junior", gender: "Female", distance: "50m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_senior_m: {rset_id: 3, age_class: "Senior", gender: "Male",   distance: "50m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_senior_w: {rset_id: 3, age_class: "Senior", gender: "Female", distance: "50m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_master_m: {rset_id: 3, age_class: "Master", gender: "Male",   distance: "50m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist3_master_w: {rset_id: 3, age_class: "Master", gender: "Female", distance: "40m", target_name: "80cm/1-spot/10-ring"}, 

    wa1440_dist4_cadet_m:  {rset_id: 4, age_class: "Cadet",  gender: "Male",   distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_cadet_w:  {rset_id: 4, age_class: "Cadet",  gender: "Female", distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_junior_m: {rset_id: 4, age_class: "Junior", gender: "Male",   distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_junior_w: {rset_id: 4, age_class: "Junior", gender: "Female", distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_senior_m: {rset_id: 4, age_class: "Senior", gender: "Male",   distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_senior_w: {rset_id: 4, age_class: "Senior", gender: "Female", distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_master_m: {rset_id: 4, age_class: "Master", gender: "Male",   distance: "30m", target_name: "80cm/1-spot/10-ring"}, 
    wa1440_dist4_master_w: {rset_id: 4, age_class: "Master", gender: "Female", distance: "30m", target_name: "80cm/1-spot/10-ring"}
}

wa_target_attrs.each do |obj, attrs|
    Target.find_or_create_by(attrs)
end

wa_category_attrs.each do |obj, attrs|
    ArcherCategory.find_or_create_by(attrs)
end

wa_set_attrs.each do |obj, attrs|
    Rset.find_or_create_by(attrs)
end

wa1440_attrs.each do |obj, details|
    ArcherCategory.where(cat_age_class: details[:age_class], cat_gender: details[:gender]).each do |category|
        DistanceTargetCategory.find_or_create_by(
            rset_id: details[:rset_id], 
            archer_category_id: category.id, 
            distance: details[:distance], 
            target_id: Target.find_by_name(details[:target_name]).id
        )
    end
end

# ##########################################################
# USA Archery Targets and Categories (pre-load)
# ##########################################################

# #### Targets ####
usa_target_attrs = {
    cm122_1spot_10ring: {size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm80_1spot_10ring: {size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm80_1spot_6ring: {size: "80cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm60_1spot_10ring: {size: "60cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm60_3spot_6ring: {size: "60cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false}, 
    cm40_1spot_10ring: {size: "40cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm40_3spot_6ring: {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false}
}

# #### Categories ####
usa_category_attrs = {
    usa_rbw: {cat_code: "USA-RBW", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Bowman", min_age: "", max_age: 12, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_ruw: {cat_code: "USA-RUW", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Cub", min_age: 13, max_age: 14, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_rcw: {cat_code: "USA-RCW", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Cadet", min_age: 15, max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_rjw: {cat_code: "USA-RJW", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_rsw: {cat_code: "USA-RW",  gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Female"}, 
    usa_rm50w: {cat_code: "USA-RM50W", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 50, max_age: 59, open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 
    usa_rm60w: {cat_code: "USA-RM60W", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 60, max_age: 69, open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 
    usa_rm70w: {cat_code: "USA-RM70W", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 70, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 
    
    usa_rbm: {cat_code: "USA-RBW", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Bowman", min_age: "", max_age: 12, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_rum: {cat_code: "USA-RUW", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Cub", min_age: 13, max_age: 14, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_rcm: {cat_code: "USA-RCM", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Cadet", min_age: 15, max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_rjm: {cat_code: "USA-RJM", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_rsm: {cat_code: "USA-RM",  gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}, 
    usa_rm50m: {cat_code: "USA-RM50M", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 50, max_age: 59, open_to_younger: false, open_to_older: true, cat_gender: "Male"}, 
    usa_rm60m: {cat_code: "USA-RM60M", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 60, max_age: 69, open_to_younger: false, open_to_older: true, cat_gender: "Male"}, 
    usa_rm70m: {cat_code: "USA-RM70M", gov_body: "USA Archery", cat_division: "Recurve", cat_age_class: "Master", min_age: 70, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Male"}, 

    usa_cbw: {cat_code: "USA-CBW", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Bowman", min_age: "", max_age: 12, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_cuw: {cat_code: "USA-CUW", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Cub", min_age: 13, max_age: 14, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_ccw: {cat_code: "USA-CCW", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Cadet", min_age: 15, max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_cjw: {cat_code: "USA-CJW", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Female"}, 
    usa_csw: {cat_code: "USA-CW",  gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Female"}, 
    usa_cm50w: {cat_code: "USA-CM50W", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 50, max_age: 59, open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 
    usa_cm60w: {cat_code: "USA-CM60W", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 60, max_age: 69, open_to_younger: false, open_to_older: true, cat_gender: "Female"}, 
    usa_cm70w: {cat_code: "USA-CM70W", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 70, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Female"},

    usa_cbm: {cat_code: "USA-CBM", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Bowman", min_age: "", max_age: 12, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_cum: {cat_code: "USA-CUM", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Cub", min_age: 13, max_age: 14, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_ccm: {cat_code: "USA-CCM", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Cadet", min_age: 15, max_age: 17, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_cjm: {cat_code: "USA-CJM", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Junior", min_age: 18, max_age: 20, open_to_younger: true, open_to_older: false, cat_gender: "Male"}, 
    usa_csm: {cat_code: "USA-CM",  gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Senior", min_age: 21, max_age: 49, open_to_younger: true, open_to_older: true, cat_gender: "Male"}, 
    usa_cm50m: {cat_code: "USA-CM50M", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 50, max_age: 59, open_to_younger: false, open_to_older: true, cat_gender: "Male"}, 
    usa_cm60m: {cat_code: "USA-CM60M", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 60, max_age: 69, open_to_younger: false, open_to_older: true, cat_gender: "Male"}, 
    usa_cm70m: {cat_code: "USA-CM70M", gov_body: "USA Archery", cat_division: "Compound", cat_age_class: "Master", min_age: 70, max_age: "", open_to_younger: false, open_to_older: true, cat_gender: "Male"}
}

# #### Standard Rsets ####


# #### Distance/Target Lookup ####


# usa_target_attrs.each do |obj, attrs|
# 	Target.find_or_create_by(attrs)
# end

# usa_category_attrs.each do |obj, attrs|
# 	ArcherCategory.find_or_create_by(attrs)
# end
   

# ##########################################################
# NFAA Targets and Categories (pre-load)
# ##########################################################
# NFAA (add later)

# #### Targets ####
# nfaa_target_attrs = {
#     cm65_1spot_5ring: {size: "65cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm50_1spot_5ring: {size: "50cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm35_1spot_5ring: {size: "35cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm20_1spot_5ring: {size: "20cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm40_1spot_5ring: {size: "40cm", score_areas: 5, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm40_5spot_3ring: {size: "40cm", score_areas: 2, rings: 3, x_ring: true, max_score: 5, spots: 5, user_edit: false}
# }

# #### Categories ####


# #### Standard Rsets ####


# #### Distance/Target Lookup ####





# ##########################################################
# 3D Targets (pre-load)
# ##########################################################
# 3D (add later)

