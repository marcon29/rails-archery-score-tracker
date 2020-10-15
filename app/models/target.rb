class Target < ApplicationRecord

    # validation notes
        # no duplicates: name
        # required: size, score_areas, rings, x_ring, max_score, spots (all but name and edit) 

    # need create name callback method: 
        # auto-creates name at time of instantiation
        # size/spot/ring = "122cm/1-spot/10-ring"

    # pre-load target list, all include an x-ring
        # 122cm: reg
        # 80cm: reg, 6-ring
        # 60cm: reg, 3-spot
        # 40cm: reg, 3-spot

    # NFAA targets, not pre-loaded, but try to account for
        # field: all have 3 score areas but 6 rings, single spot
            # 65cm, 50cm, 35cm, 20cm
        # indoor: 
            # 40cm: 5 score areas, 5 rings (w/ X-ring), single spot
            # 40cm: 2 score areas, 4 rings (w/ X-ring), 5-spot
end
