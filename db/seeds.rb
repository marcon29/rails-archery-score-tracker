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
# pre-load target list, all include an x-ring
    # 122cm: reg
    # 80cm: reg, 6-ring
    # 60cm: reg, 3-spot
    # 40cm: reg, 3-spot

# NFAA targets, not pre-loaded, but try to account for
    # field: 
        # all have 3 score areas but 6 rings, single spot
        # all score 5 through 3
        # 65cm, 50cm, 35cm, 20cm
    # indoor: 
        # 40cm: 5 score areas, 5 rings (w/ X-ring), single spot
        # 40cm: 2 score areas, 4 rings (w/ X-ring), 5-spot



# ##########################################################
# Archer categories to pre-load
# ##########################################################
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

