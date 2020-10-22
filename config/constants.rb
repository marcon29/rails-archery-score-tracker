# #########################################################################
# Enter new archery association details here
# Enter all data as you'd like it to appear in app views
# #########################################################################

# AGE_CLASSES hash keys also used to create GOV_BODIES, array values can't contain spaces
AGE_CLASSES = {
    "World Archery" => ["Cadet", "Junior", "Senior", "Master"], 
    "USA Archery" => ["Bowman", "Cub", "Cadet", "Junior", "Senior", "Master50", "Master60", "Master70"]
}
DIVISIONS = ["Recurve", "Compound"]


DISCIPLINES = ["Outdoor", "Indoor"]
ROUND_TYPES = ["Qualifying", "Match"]
SCORE_METHODS = ["Points", "Set"]

# #########################################################################
# these are for user or app functionality, shouldn't need to change
# #########################################################################
GENDERS = ["Male", "Female"]
SCORE_SESSION_TYPES = ["Tournament", "Leage", "Competition", "Practice"]
GOV_BODIES = AGE_CLASSES.keys