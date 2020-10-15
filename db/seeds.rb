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
# USA Archery
# NFAA (add later)
# 3D (add later)

