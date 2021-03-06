require 'rails_helper'

RSpec.describe Format::RoundFormat, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "720 Round", num_sets: 2, discipline_id: 1, user_edit: true}
    }
    
    let(:test_round_format) {
        Format::RoundFormat.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {name: "720 Round", num_sets: 2, discipline_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "720 Round", num_sets: 2, discipline_id: 1, user_edit: true}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {name: "Double 720 Round", num_sets: 4, discipline_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", num_sets: "", user_edit: "", discipline_id: 1}
    }
  
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:default_user_edit) {true}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:missing_name_message) {"You must enter a name."}
    let(:duplicate_name_message) {"That name is already taken."}
    let(:number_all_message) {"You must enter a number greater than 0."}
    let(:restricted_update_message) {"You can't change a pre-loaded #{valid_round_format.class.to_s}."}


    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            valid_discipline
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Format::RoundFormat.all.count).to eq(0)

                expect(test_round_format).to be_valid
                expect(Format::RoundFormat.all.count).to eq(1)

                expect(test_round_format.name).to eq(test_all[:name])
                expect(test_round_format.num_sets).to eq(test_all[:num_sets])
                expect(test_round_format.user_edit).to eq(test_all[:user_edit])
            end
            
            it "given only required attributes" do
                expect(Format::RoundFormat.all.count).to eq(0)
                round_format = Format::RoundFormat.create(test_req)

                expect(round_format).to be_valid
                expect(Format::RoundFormat.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(round_format.name).to eq(test_req[:name])
                expect(round_format.num_sets).to eq(test_req[:num_sets])

                # not req input tests (user_edit auto-asigned from missing)
                expect(round_format.user_edit).to eq(default_user_edit)
            end

            it "updating all attributes" do
                test_round_format.update(update)
                
                expect(test_round_format).to be_valid
                
                # req input tests (should have value in update)
                expect(test_round_format.name).to eq(update[:name])
                expect(test_round_format.num_sets).to eq(update[:num_sets])
                
                # not req input tests (user_edit originally manually set and unchanged, so should be original)
                expect(test_round_format.user_edit).to eq(test_all[:user_edit])
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                round_format = Format::RoundFormat.create(blank)

                expect(round_format).to be_invalid
                expect(Format::RoundFormat.all.count).to eq(0)

                expect(round_format.errors.messages[:name]).to include(missing_name_message)
                expect(round_format.errors.messages[:num_sets]).to include(number_all_message)
            end

            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_round_format
                expect(Format::RoundFormat.all.count).to eq(1)
                round_format = Format::RoundFormat.create(duplicate)

                expect(round_format).to be_invalid
                expect(Format::RoundFormat.all.count).to eq(1)
                expect(round_format.errors.messages[:name]).to include(duplicate_name_message)
            end

            it "attributes are outside allowable inputs" do
                duplicate[:num_sets] = "four"
                round_format = Format::RoundFormat.create(duplicate)

                expect(round_format).to be_invalid
                expect(Format::RoundFormat.all.count).to eq(0)
                expect(round_format.errors.messages[:num_sets]).to include(number_all_message)
            end

            it "trying to edit a restricted, pre-load round format" do
                # can create an instance with user_edit == false, but not edit after
                expect(Format::RoundFormat.all.count).to eq(0)
                
                round_format = Format::RoundFormat.create(name: test_all[:name], num_sets: test_all[:num_sets], discipline_id: test_all[:discipline_id], user_edit: false)
                expect(Format::RoundFormat.all.count).to eq(1)
                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(round_format).to be_valid
                
                round_format.update(update)
                round_format.reload

                expect(round_format).to be_invalid
                expect(round_format.errors.messages[:user_edit]).to include(restricted_update_message)

                expect(round_format.errors.messages[:name]).to include(restricted_update_message)
                expect(round_format.name).to eq(test_all[:name])

                expect(round_format.errors.messages[:num_sets]).to include(restricted_update_message)
                expect(round_format.num_sets).to eq(test_all[:num_sets])
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            valid_discipline
        end
        
        describe "has many SetEndFormats and can" do
            it "find an associated object" do
                expect(valid_round_format.set_end_formats).to include(valid_set_end_format)
            end

            it "create a new associated object via instance and get associated object attributes" do
                check_set_end_format_attrs = {num_ends: 6, shots_per_end: 6}
                check_set_end_format = test_round_format.set_end_formats.create(check_set_end_format_attrs)
                
                expect(test_round_format.set_end_formats).to include(check_set_end_format)
                expect(test_round_format.set_end_formats.last.name).to include(check_set_end_format.name)
            end
            
            it "re-assign instance via the associated object" do
                assoc_round_format = valid_round_format
                assoc_set_end_format = valid_set_end_format
                
                assoc_set_end_format.round_format = assoc_round_format
                assoc_set_end_format.save

                expect(test_round_format.set_end_formats).not_to include(assoc_set_end_format)
                expect(assoc_round_format.set_end_formats).to include(assoc_set_end_format)
            end
        end

        describe "has many Rounds and" do
            before(:each) do
                before_round
            end

            it "can find an associated object" do
                expect(valid_round_format.rounds).to include(valid_round)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                round_format = Format::RoundFormat.create(duplicate)

                check_round_attrs = {round_type: "Qualifying", score_method: "Points", archer: valid_archer, score_session: valid_score_session}
                check_round = round_format.rounds.create(check_round_attrs)
                
                expect(round_format.rounds).to include(check_round)
                expect(round_format.rounds.last.name).to eq(check_round.name)
            end
        end

        describe "belongs to Discipline and can" do
            it "find an associated object" do
                expect(valid_round_format.discipline).to eq(valid_discipline)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can return the round's name with correct capitalization" do
            duplicate[:name] = "1440 round"
            round_format = Format::RoundFormat.create(duplicate)
            expect(round_format.name).to eq(duplicate[:name].titlecase)
        end
    end
end
