# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ##########################################################
# To re-use the db:seed task, use .find_or_create_by instead of .create. 
# However, should only use task to populate DB when project created. 
# To perform complex data seeding during the app lifecycle, create a new rake task, execute it then remove it.
# ##########################################################


# ##########################################################
# Targets to pre-load
# ##########################################################
wa_target_attrs = {
    cm122_1spot_10ring: {size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm80_1spot_10ring: {size: "80cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm80_1spot_6ring: {size: "80cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm60_1spot_10ring: {size: "60cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm60_3spot_6ring: {size: "60cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false}, 
    cm40_1spot_10ring: {size: "40cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false}, 
    cm40_3spot_6ring: {size: "40cm", score_areas: 6, rings: 6, x_ring: true, max_score: 10, spots: 3, user_edit: false}
}

# nfaa_target_attrs = {
#     cm65_1spot_5ring: {size: "65cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm50_1spot_5ring: {size: "50cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm35_1spot_5ring: {size: "35cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm20_1spot_5ring: {size: "20cm", score_areas: 3, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm40_1spot_5ring: {size: "40cm", score_areas: 5, rings: 5, x_ring: true, max_score: 5, spots: 1, user_edit: false}, 
#     cm40_5spot_3ring: {size: "40cm", score_areas: 2, rings: 3, x_ring: true, max_score: 5, spots: 5, user_edit: false}
# }

wa_target_attrs.each do |target, attrs| 
	Target.find_or_create(attrs)
end

# ##########################################################
# Archer categories to pre-load
# ##########################################################


# category_attrs = {
#     {cat_code: "RM", gov_body: "World Archery", cat_division: "Recurve", cat_age_class: "Senior", min_age: nil, max_age: nil, cat_gender: "Male"}
# }

# category_attrs.each do |cat, attrs|
# 	ArcherCategory.find_or_create(attrs)
# end

# World Archery
    # WA-RCW - Recurve Cadet Women
    # WA-RJW - Recurve Junior Women
    # WA-RW - Recurve Senior Women
    # WA-RMW - Recurve Master Women
    
    # WA-RCM - Recurve Cadet Men
    # WA-RJM - Recurve Junior Men
    # WA-RM - Recurve Senior Men
    # WA-RMM - Recurve Master Men
    
    # WA-CCW - Compound Cadet Women
    # WA-CJW - Compound Junior Women
    # WA-CW - Compound Senior Women
    # WA-CMW - Compound Master Women
    
    # WA-CCM - Compound Cadet Men
    # WA-CJM - Compound Junior Men
    # WA-CM - Compound Senior Men
    # WA-CMM - Compound Master Men

# USA Archer
    # USA-RBW - Recurve Bowman Women
    # USA-RUW - Recurve Cub Women
    # USA-RCW - Recurve Cadet Women
    # USA-RJW - Recurve Junior Women
    # USA-RW - Recurve Senior Women
    # USA-RM50W - Recurve Master50 Women
    # USA-RM60W - Recurve Master60 Women
    # USA-RM70W - Recurve Master70 Women

    # USA-RBM - Recurve Bowman Men
    # USA-RUM - Recurve Cub Men
    # USA-RCM - Recurve Cadet Men
    # USA-RJM - Recurve Junior Men
    # USA-RM - Recurve Senior Men
    # USA-RM50M - Recurve Master50 Men
    # USA-RM60M - Recurve Master60 Men
    # USA-RM70M - Recurve Master70 Men
    
    # USA-CBW - Compound Bowman Women
    # USA-CUW - Compound Cub Women
    # USA-CCW - Compound Cadet Women
    # USA-CJW - Compound Junior Women
    # USA-CW - Compound Senior Women
    # USA-CM50W - Compound Master50 Women
    # USA-CM60W - Compound Master60 Women
    # USA-CM70W - Compound Master70 Women
    
    # USA-CBM - Compound Bowman Men
    # USA-CUM - Compound Cub Men
    # USA-CCM - Compound Cadet Men
    # USA-CJM - Compound Junior Men
    # USA-CM - Compound Senior Men
    # USA-CM50M - Compound Master50 Men
    # USA-CM60M - Compound Master60 Men
    # USA-CM70M - Compound Master70 Men
# NFAA (add later)
# 3D (add later)

