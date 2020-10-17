class DistanceTarget < ApplicationRecord

    # need to add associations


    # Regular user can't update these, pre-loaded for reference by rest of app only,
    # but validations still helpful to ensure data integrity when extending app.
    # This also means there's no need to  display error messages.
    # need to add validations
        # has a distance
        # won't duplicate record (checks all columns)

        


    # methods needed
        # format distance - combines distance (integer) and unit (string) into single string w/ no spaces



    # what pre-load data should look like
        # (set_id: 1, , archer_category_id: 1, distance: "90m", target_id: 1)

        # set = Round/set/distanceX (X is number)
        # arch_cat = find from ArcherCategory model by cat_code
        # distance = list
        # target = find from Target model
end
