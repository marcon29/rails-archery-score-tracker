require 'rails_helper'

RSpec.describe RoundSet, type: :model do
    let(:valid_all) {
        {name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points"}
    }

    let(:test_round_set) {
        RoundSet.create(valid_all)
    }

    #  all instances of AssocModels needed for testing associations (not persisted until called)
    # let(:assoc_archer) {
    #     Archer.create(
    #         username: "testuser", 
    #         email: "testuser@example.com", 
    #         password: "test", 
    #         first_name: "Test", 
    #         last_name: "User", 
    #         birthdate: "1980-07-01", 
    #         gender: "Male", 
    #         home_city: "Denver", 
    #         home_state: "CO", 
    #         home_country: "USA", 
    #         default_age_class: "Senior"
    #     )
    # }

    # let(:assoc_score_session) {
    #     ScoreSession.create(
    #         name: "2020 World Cup", 
    #         score_session_type: "Tournament", 
    #         city: "Oxford", 
    #         state: "OH", 
    #         country: "USA", 
    #         start_date: "2020-09-01", 
    #         end_date: "2020-09-05", 
    #         rank: "1st", 
    #         active: true
    #     )
    # }

    let(:assoc_round) {
        Round.create(name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4, user_edit: false)
    }

    # let(:assoc_shot) {
    #   Shot.create()
    # }

    let(:assoc_category) {
        ArcherCategory.create(
            cat_code: "WA-RM", 
            gov_body: "World Archery", 
            cat_division: "Recurve", 
            cat_age_class: "Senior", 
            min_age: 21, 
            max_age: 49, 
            open_to_younger: true, 
            open_to_older: true, 
            cat_gender: "Male"
        )
    }
    
    let(:assoc_target) {
        Target.create(size: "122cm", score_areas: 10, rings: 10, x_ring: true, max_score: 10, spots: 1, user_edit: false)
    }  

    let(:assoc_dist_targ) {
        DistanceTarget.create(distance: "90m", target_id: 1, archer_category_id: 1, round_set_id: 1)
    }

    # remove any non-required atts, and auto-assign (not auto_format) attrs, all should be formatted correctly already
    # all are required - name is auto-assigned at controller level
    # let(:valid_req) {
    #     {ends: 6, shots_per_end: 6, score_method: "Points"}
    # }

    # exact duplicate of valid_all - use as whole for testing unique values, use for testing specific atttrs (bad inclusion, bad format, etc.)
    let(:duplicate) {
        {name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points"}
    }

    # start w/ valid_all, change all values, make any auto-assign blank (don't delete)
    let(:update) {
        {name: "720 Round - Set/Distance1", ends: 12, shots_per_end: 3, score_method: "Set"}
    }

    # every attr blank
    let(:blank) {
        {name: "", ends: "", shots_per_end: "", score_method: ""}
    }
    
    # add the following default error messages for different validation failures (delete any unnecessary for model)
    let(:default_missing_message) {"can't be blank"}
    let(:default_duplicate_message) {"has already been taken"}
    let(:default_inclusion_message) {"is not included in the list"}
    let(:default_number_message) {"is not a number"}
    let(:default_format_message) {"is invalid"}
    
    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances" do
        describe "valid with all required and unrequired input data" do
            it "instance is valid with all attributes (all are required)" do
                expect(RoundSet.all.count).to eq(0)

                expect(test_round_set).to be_valid
                expect(RoundSet.all.count).to eq(1)
                
                expect(test_round_set.name).to eq(valid_all[:name])
                expect(test_round_set.ends).to eq(valid_all[:ends])
                expect(test_round_set.shots_per_end).to eq(valid_all[:shots_per_end])
                expect(test_round_set.score_method).to eq(valid_all[:score_method])
            end

            # it "instance is valid with only required attributes, auto-assigns name" do
            #     expect(RoundSet.all.count).to eq(0)
            #     round_set = RoundSet.create(valid_req)

            #     expect(round_set).to be_valid
            #     expect(RoundSet.all.count).to eq(1)

            #     # req input tests
            #     expect(round_set.ends).to eq(valid_req[:ends])
            #     expect(round_set.shots_per_end).to eq(valid_req[:shots_per_end])
            #     expect(round_set.score_method).to eq(valid_req[:score_method])
                
            #     # not req input tests (name auto-asigned from missing)
            #     expect(round_set.name).to eq("1440 Round - Set/Distance1")
            # end

            it "instance is valid when updating all attrs, re-assigns name if value deleted" do
                test_round_set.update(update)
                
                # req input tests (should have value in update)
                expect(test_round_set.name).to eq(update[:name])
                expect(test_round_set.ends).to eq(update[:ends])
                expect(test_round_set.shots_per_end).to eq(update[:shots_per_end])
                expect(test_round_set.score_method).to eq(update[:score_method])
            end
        end
    
        describe "invalid if input data is missing or bad" do
            it "is invalid and has correct error message without required attributes" do
                round_set = RoundSet.create(blank)

                expect(round_set).to be_invalid
                expect(RoundSet.all.count).to eq(0)
                expect(round_set.errors.messages[:name]).to include(default_missing_message)
                expect(round_set.errors.messages[:ends]).to include("You must enter a number greater than 0.")
                expect(round_set.errors.messages[:shots_per_end]).to include("You must enter a number greater than 0.")
                expect(round_set.errors.messages[:score_method]).to include("You must choose a score method.")
            end
            
            it "is invalid and has correct error message when unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_round_set
                round_set = RoundSet.create(duplicate)

                expect(round_set).to be_invalid
                expect(RoundSet.all.count).to eq(1)
                expect(round_set.errors.messages[:name]).to include(default_duplicate_message)
            end

            # it "if auto-created roundset name already exists, will return that object instead" do
            #     pending "do this or the duplication error above"
            #     pending "straight dupliction error seems better for an update test"
            #     # need to call initial test object to check against for duplication
            #     test_round_set
            #     round_set = RoundSet.create(duplicate)

            #     expect(RoundSet.all.count).to eq(1)
            #     expect(round_set.id).to eq(test_round_set.id)
            # end

            it "is invalid and has correct error message if value not included in corresponding selection list or is wrong format" do
                duplicate[:ends] = "six"
                duplicate[:shots_per_end] = "six"
                duplicate[:score_method] = "bad data"
                round_set = RoundSet.create(duplicate)

                expect(round_set).to be_invalid
                expect(round_set.errors.messages[:score_method]).to include(default_inclusion_message)
                expect(round_set.errors.messages[:ends]).to include("You must enter a number greater than 0.")
                expect(round_set.errors.messages[:shots_per_end]).to include("You must enter a number greater than 0.")
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            test_round_set
            assoc_target
            assoc_category
            assoc_dist_targ
        end

        it "has many Archers" do
            pending "need to add create associated models and add associations"
            expect(test_round_set.archer).to include(assoc_archer)
        end

        it "has many ScoreSessons" do
            pending "need to add create associated models and add associations"
            expect(test_round_set.rounds).to include(assoc_round)
        end

        it "has many RoundSets" do
            pending "need to add create associated models and add associations"
            expect(test_round_set.round_sets).to include(assoc_round_set)
        end
    
        it "has many Shots" do
            pending "need to add create associated models and add associations"
            expect(test_round_set.shots).to include(assoc_shot)
        end

        it "has many ArcherCategories" do
            expect(test_round_set.archer_categories).to include(assoc_category)
        end

        it "has many Targets" do
            expect(test_round_set.targets).to include(assoc_target)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_round_set).to be_invalid
        end
    end
end
