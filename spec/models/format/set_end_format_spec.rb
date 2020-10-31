require 'rails_helper'

RSpec.describe Format::SetEndFormat, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {name: "Set/Distance2", num_ends: 6, shots_per_end: 6, user_edit: true, round_format_id: 1}
    }

    let(:test_set_end_format) {
        Format::SetEndFormat.create(test_all)
    }

    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {num_ends: 6, shots_per_end: 6, round_format_id: 1}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {name: "Set/Distance2", num_ends: 6, shots_per_end: 6, user_edit: true, round_format_id: 1}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {num_ends: 12, shots_per_end: 3, round_format_id: 1}
    }

    # every attr blank
    let(:blank) {
        {name: "", num_ends: "", shots_per_end: "", user_edit: "", round_format_id: 1}
    }
    
    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    let(:assigned_name_first) {"Set/Distance1"}
    let(:assigned_name_second) {"Set/Distance2"}
    let(:default_user_edit) {true}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    let(:too_many_sets_message) {"You can't exceed the number of sets for this round format."}
    let(:number_all_message) {"You must enter a number greater than 0."}
    let(:restricted_update_message) {"You can't change a pre-loaded #{valid_set_end_format.class.to_s}."}
    
    
    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        before(:each) do
            valid_round_format
        end

        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Format::SetEndFormat.all.count).to eq(0)

                expect(test_set_end_format).to be_valid
                expect(Format::SetEndFormat.all.count).to eq(1)
                
                expect(test_set_end_format.name).to eq(test_all[:name])
                expect(test_set_end_format.num_ends).to eq(test_all[:num_ends])
                expect(test_set_end_format.shots_per_end).to eq(test_all[:shots_per_end])
                expect(test_set_end_format.user_edit).to eq(test_all[:user_edit])
            end

            it "given only required attributes" do
                valid_set_end_format

                expect(Format::SetEndFormat.all.count).to eq(1)
                set_end_format = Format::SetEndFormat.create(test_req)

                expect(set_end_format).to be_valid
                expect(Format::SetEndFormat.all.count).to eq(2)

                # req input tests (should have value in test_req)
                expect(set_end_format.num_ends).to eq(test_req[:num_ends])
                expect(set_end_format.shots_per_end).to eq(test_req[:shots_per_end])
                
                # not req input tests (name and user_edit auto-asigned from missing)
                expect(set_end_format.name).to eq(assigned_name_second)
                expect(set_end_format.user_edit).to eq(default_user_edit)
            end

            it "updating all attributes" do
                test_set_end_format.update(update)

                expect(test_set_end_format).to be_valid
                
                # req input tests (should have value in update)
                expect(test_set_end_format.num_ends).to eq(update[:num_ends])
                expect(test_set_end_format.shots_per_end).to eq(update[:shots_per_end])
                
                # not req input tests (name auto-asigned from blank, user_edit originally manually set and unchanged, so should be original)
                expect(test_set_end_format.name).to eq(assigned_name_second)
                expect(test_set_end_format.user_edit).to eq(test_all[:user_edit])
            end

            it "name is duplicated but for different Format::RoundFormat" do
                # need two round_formats
                Format::RoundFormat.create(name: "720 Round", num_sets: 4, user_edit: false)
                expect(Format::RoundFormat.all.count).to eq(2)
                expect(Format::SetEndFormat.all.count).to eq(0)

                # gives me 2 se_forms in valid_round_format
                valid_set_end_format
                test_set_end_format
                expect(Format::SetEndFormat.all.count).to eq(2)
                
                # gives me 1 se_form in second_round_format
                third_set_end_format = Format::SetEndFormat.create(name: "Set/Distance1", num_ends: 6, shots_per_end: 6, round_format_id: 2)
                expect(Format::SetEndFormat.all.count).to eq(3)

                # test duped name from valid_round_format but in second_round_format
                duplicate[:round_format_id] = 2
                set_end_format = Format::SetEndFormat.create(duplicate)

                expect(set_end_format).to be_valid
                expect(Format::SetEndFormat.all.count).to eq(4)

                expect(set_end_format.name).to eq(assigned_name_second)
                expect(set_end_format.num_ends).to eq(duplicate[:num_ends])
                expect(set_end_format.shots_per_end).to eq(duplicate[:shots_per_end])
                expect(set_end_format.user_edit).to eq(duplicate[:user_edit])
            end
        end
    
        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                set_end_format = Format::SetEndFormat.create(blank)

                expect(set_end_format).to be_invalid
                expect(Format::SetEndFormat.all.count).to eq(0)

                expect(set_end_format.errors.messages[:num_ends]).to include(number_all_message)
                expect(set_end_format.errors.messages[:shots_per_end]).to include(number_all_message)
            end
            
            it "unique attributes are duplicated" do
                # need to call initial test object to check against for duplication
                test_set_end_format
                expect(Format::SetEndFormat.all.count).to eq(1)
                set_end_format = Format::SetEndFormat.create(duplicate)

                expect(set_end_format).to be_invalid
                expect(Format::SetEndFormat.all.count).to eq(1)
                expect(set_end_format.errors.messages[:name]).to include(default_duplicate_message)
            end

            it "exceeds the total number of SetEndFormats allowable for the RoundFormat" do
                expect(Format::SetEndFormat.all.count).to eq(0)
                valid_round_format.num_sets.times { Format::SetEndFormat.create(test_req) }
                expect(Format::SetEndFormat.all.count).to eq(4)

                set_end_format = Format::SetEndFormat.create(test_req)

                expect(set_end_format).to be_invalid
                expect(Format::SetEndFormat.all.count).to eq(4)
                expect(set_end_format.errors.messages[:name]).to include(too_many_sets_message)
            end

            it "attributes are outside allowable inputs" do
                duplicate[:num_ends] = "six"
                duplicate[:shots_per_end] = "six"
                set_end_format = Format::SetEndFormat.create(duplicate)

                expect(set_end_format).to be_invalid
                expect(Format::SetEndFormat.all.count).to eq(0)
                expect(set_end_format.errors.messages[:num_ends]).to include(number_all_message)
                expect(set_end_format.errors.messages[:shots_per_end]).to include(number_all_message)
            end

            it "trying to edit a restricted, pre-load round format" do
                # can create an instance with user_edit == false, but not edit after
                expect(Format::SetEndFormat.all.count).to eq(0)
                set_end_format = Format::SetEndFormat.create(num_ends: test_all[:num_ends], shots_per_end: test_all[:shots_per_end], user_edit: false, round_format_id: 1)
                expect(Format::SetEndFormat.all.count).to eq(1)
                # keeping this until figure out why it won't run validity test correctly (works fine in console)
                # expect(set_end_format).to be_valid
                
                set_end_format.update(update)
                set_end_format.reload

                expect(set_end_format).to be_invalid
                expect(set_end_format.errors.messages[:user_edit]).to include(restricted_update_message)

                expect(set_end_format.errors.messages[:name]).to include(restricted_update_message)
                expect(set_end_format.name).to eq(assigned_name_first)

                expect(set_end_format.errors.messages[:num_ends]).to include(restricted_update_message)
                expect(set_end_format.num_ends).to eq(test_all[:num_ends])

                expect(set_end_format.errors.messages[:shots_per_end]).to include(restricted_update_message)
                expect(set_end_format.shots_per_end).to eq(test_all[:shots_per_end])
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        describe "belongs to RoundFormat and can" do
            it "find an associated object" do
                assoc_round_format = valid_round_format
                expect(test_set_end_format.round_format).to eq(assoc_round_format)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_round_format = valid_round_format
                update[:round_format_id] = ""
                check_set_end_format = assoc_round_format.set_end_formats.create(update)
                
                expect(check_set_end_format.round_format).to eq(assoc_round_format)
                expect(check_set_end_format.round_format.name).to include(assoc_round_format.name)
            end
        end

        describe "has many Rsets and" do
            before(:each) do
                before_rset
            end

            it "can find an associated object" do
                expect(valid_set_end_format.rsets).to include(valid_rset)
            end

            it "can create a new associated object via instance and get associated object attributes" do
                set_end_format = Format::SetEndFormat.create(duplicate)

                check_rset_attrs = {date: "2020-09-01", archer: valid_archer, score_session: valid_score_session, round: valid_round}
                check_rset = set_end_format.rsets.create(check_rset_attrs)
                
                expect(set_end_format.rsets).to include(check_rset)
                expect(set_end_format.rsets.last.name).to eq(check_rset.name)
            end
        end

        describe "has many DistanceTargetCategories and" do
            it "can find an associated object" do
                expect(valid_set_end_format.distance_target_categories).to include(valid_dist_targ_cat)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "can find all the Format::SetEndFormats belonging to the same Format::RoundFormat" do
            valid_round_format
            second_round_format = Format::RoundFormat.create(name: "720 Round", num_sets: 1, user_edit: false)
            expect(Format::RoundFormat.count).to eq(2)

            first_set_end_foramt = valid_set_end_format
            second_set_end_foramt = test_set_end_format
            other_set_end_format = Format::SetEndFormat.create(num_ends: 6, shots_per_end: 6, user_edit: false, round_format: second_round_format)
            expect(Format::SetEndFormat.count).to eq(3)

            expect(first_set_end_foramt.sets_in_round.count).to eq(2)
            expect(first_set_end_foramt.sets_in_round).to include(first_set_end_foramt)
            expect(first_set_end_foramt.sets_in_round).to include(second_set_end_foramt)
            expect(first_set_end_foramt.sets_in_round).not_to include(other_set_end_format)
        end

        it "can identify the total number of Format::SetEndFormats allowed in its Format::RoundFormat" do
            valid_round_format
            expect(test_set_end_format.allowable_sets_per_round).to eq(valid_round_format.num_sets)
        end
    end
end
