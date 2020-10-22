require 'rails_helper'

RSpec.describe Round, type: :model do
    let(:valid_all) {
        {name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4, user_edit: false}
    }
    
    let(:test_round) {
        Round.create(valid_all)
    }
    
    # add all instances of AssocModel needed for testing associations (not persisted until called)
        # should be valid with all attrs
    let(:assoc_archer) {
        Archer.create(
            username: "testuser", 
            email: "testuser@example.com", 
            password: "test", 
            first_name: "Test", 
            last_name: "User", 
            birthdate: "1980-07-01", 
            gender: "Male", 
            home_city: "Denver", 
            home_state: "CO", 
            home_country: "USA", 
            default_age_class: "Senior"
        )
    }

    let(:assoc_set) {
        Set.create(name: "1440 Round - Set/Distance1", ends: 6, shots_per_end: 6, score_method: "Points")
    }

    # let(:assoc_shot) {
    #   Shot.create()
    # }

    let(:assoc_category_senior) {
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
        DistanceTargetCategory.create(distance: "90m", target_id: 1, archer_category_id: 1, set_id: 1)
    }
    
    # take valid_all and remove any non-required atts and auto-assign (not auto_format) attrs, all should be formatted correctly already
    let(:valid_req) {
        {name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4}
    }

    # exact duplicate of valid_all - use as whole for testing unique values
    # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.)
    let(:duplicate) {
        {name: "1440 Round", discipline: "Outdoor", round_type: "Qualifying", num_roundsets: 4, user_edit: false}
    }

    # start w/ valid_all, change all values, make any auto-assign blank (don't delete)
    let(:update) {
        {name: "720 Round", discipline: "Indoor", round_type: "Match", num_roundsets: 2}
    }

    # every attr blank
    let(:blank) {
        {name: "", discipline: "", round_type: "", num_roundsets: ""}
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
            it "instance is valid with all attributes" do
                expect(Round.all.count).to eq(0)

                expect(test_round).to be_valid
                expect(Round.all.count).to eq(1)
                expect(test_round.name).to eq(valid_all[:name])
                expect(test_round.discipline).to eq(valid_all[:discipline])
                expect(test_round.round_type).to eq(valid_all[:round_type])
                expect(test_round.num_roundsets).to eq(valid_all[:num_roundsets])
                expect(test_round.user_edit).to eq(valid_all[:user_edit])
            end
            
            it "instance is valid with only required attributes, auto-assigns user_edit" do
                expect(Round.all.count).to eq(0)
                round = Round.create(valid_req)

                expect(round).to be_valid
                expect(Round.all.count).to eq(1)

                # req input tests (should have value in valid_req)
                expect(round.name).to eq(valid_req[:name])
                expect(round.discipline).to eq(valid_req[:discipline])
                expect(round.round_type).to eq(valid_req[:round_type])
                expect(round.num_roundsets).to eq(valid_req[:num_roundsets])

                # not req input tests (user_edit auto-asigned from missing)
                expect(round.user_edit).to eq(true)
            end

            it "instance is valid when updating all attrs, does not re-assign user_edit if value deleted" do
                test_round.update(update)
                
                expect(test_round).to be_valid
                
                # req input tests (should have value in update)
                expect(test_round.name).to eq(update[:name])
                expect(test_round.discipline).to eq(update[:discipline])
                expect(test_round.round_type).to eq(update[:round_type])
                expect(test_round.num_roundsets).to eq(update[:num_roundsets])

                # user_edit auto-asigned from blank
                expect(test_round.user_edit).to eq(false)
            end
        end

        describe "invalid if input data is missing or bad" do
            it "is invalid and has correct error message without required attributes" do
                round = Round.create(blank)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(0)
                expect(round.errors.messages[:name]).to include("You must enter a name.")
                expect(round.errors.messages[:discipline]).to include("You must choose a discipline.")
                expect(round.errors.messages[:round_type]).to include("You must choose a round type.")
                expect(round.errors.messages[:num_roundsets]).to include("You must enter a number greater than 0.")
                expect(round.user_edit).to eq(true)
            end

            it "is invalid and has correct error message when unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_round
                expect(Round.all.count).to eq(1)

                round = Round.create(duplicate)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(1)
                expect(round.errors.messages[:name]).to include("That name is already taken.")
            end

            it "is invalid and has correct error message if value not included in corresponding selection list or is wrong format" do
                duplicate[:discipline] = "bad discipline"
                duplicate[:round_type] = "bad type"
                duplicate[:num_roundsets] = "four"
                round = Round.create(duplicate)

                expect(round).to be_invalid
                expect(Round.all.count).to eq(0)
                expect(round.errors.messages[:discipline]).to include(default_inclusion_message)
                expect(round.errors.messages[:round_type]).to include(default_inclusion_message)
                expect(round.errors.messages[:num_roundsets]).to include("You must enter a number greater than 0.")
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load all AssocModels that must be in DB for tests to work
        end

        it "has many Archers" do
            pending "need to add create associated models and add associations"
            expect(test_round.archer).to include(assoc_archer)
        end

        it "has many ScoreSessons" do
            pending "need to add create associated models and add associations"
            expect(test_round.rounds).to include(assoc_round)
        end

        it "has many Sets" do
            pending "need to add create associated models and add associations"
            expect(test_round.sets).to include(assoc_set)
        end
    
        it "has many Shots" do
            pending "need to add create associated models and add associations"
            expect(test_round.shots).to include(assoc_shot)
        end
    
        it "has many ArcherCategories" do
            pending "need to add create associated models and add associations"
            expect(test_round.archer_categories).to include(assoc_category)
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the round's name with correct capitalization" do
            duplicate[:name] = "1440 round"
            round = Round.create(duplicate)
            expect(round.name).to eq(duplicate[:name].titlecase)
        end

        it "helpers TBD" do
            pending "add as needed"
            expect(test_round).to be_invalid
        end
    end
end
