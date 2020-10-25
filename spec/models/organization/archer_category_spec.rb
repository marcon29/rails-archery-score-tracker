require 'rails_helper'

# to get template up and running quickly, do a find/replace (match capitalization, don't use whole word) of the following:
    #    <find>           -->             <replace>
    # Organization::ArcherCategory           -->  <actual ModelName for this model> 
    # archer_category          -->  <actual model_name for this model>
    # assoc_model_parent  -->  <actual model_name for associated parent model>
    # assoc_model_child   -->  <actual model_name for for associated child model>

RSpec.describe Organization::ArcherCategory, type: :model do
    # ###################################################################
    # define main test object
    # ###################################################################
    # needs to be different from valid object in RailsHelper to avoid duplicte failures
    let(:test_all) {
        {}
    }
        
    let(:test_archer_category) {
        Organization::ArcherCategory.create(test_all)
    }

    # ###################################################################
    # define any additional objects to test for this model 
    # ###################################################################
    # only add multiple instantiations if need simultaneous instances for testing


    # ###################################################################
    # define standard create/update variations
    # ###################################################################
    
    # take test_all and remove any non-required attrs and auto-assign (not auto_format) attrs, all should be formatted correctly
    let(:test_req) {
        {attr: value}
    }

    # exact duplicate of test_all
        # use as whole for testing unique values
        # use for testing specific atttrs (bad inclusion, bad format, helpers, etc.) - change in test itself
    let(:duplicate) {
        {attr: value}
    }

    # start w/ test_all, change all values, make any auto-assign blank (don't delete), delete any attrs with DB defaults
    let(:update) {
        {attr: value}
    }

    # every attr blank
    let(:blank) {
        {attr: value}
    }

    # ###################################################################
    # define test results for auto-assign attrs
    # ###################################################################
    # let(:assigned_attr) {}
    # let(:default_attr) {}
  
    # ###################################################################
    # define custom error messages
    # ###################################################################
    # let(:missing_attr_message) {}
    # let(:duplicate_attr_message) {}
    # let(:inclusion_attr_message) {}
    # let(:number_attr_message) {}
    # let(:format_attr_message) {}
    

    # ###################################################################
    # define tests
    # ###################################################################

    # object creation and validation tests #######################################
    describe "model creates and updates only valid instances - " do
        describe "valid when " do
            it "given all required and unrequired attributes" do
                expect(Organization::ArcherCategory.all.count).to eq(0)

                expect(test_archer_category).to be_valid
                expect(Organization::ArcherCategory.all.count).to eq(1)

                expect(test_archer_category.attr).to eq(test_all[:attr])
                # add expect for every attr
            end
            
            it "given only required attributes" do
                expect(Organization::ArcherCategory.all.count).to eq(0)
                archer_category = Organization::ArcherCategory.create(test_req)

                expect(archer_category).to be_valid
                expect(Organization::ArcherCategory.all.count).to eq(1)

                # req input tests (should have value in test_req)
                expect(archer_category.attr).to eq(test_req[:attr])
                # add expect for all req attrs

                # not req input tests (<list attrs> auto-asigned from missing)
                # add expect for all non-req attrs
            end

            it "updating all attributes" do
                test_archer_category.update(update)
                
                expect(test_archer_category).to be_valid
                
                # req input tests (should have value in update)
                expect(test_archer_category.attr).to eq(update[:attr])
                # add expect for all req attrs
                
                # not req input tests (<list attrs> auto-asigned from blank)
                # add expect for all auto-assigned attrs
            end
        end

        describe "invalid and has correct error message when" do
            it "missing required attributes" do
                archer_category = Organization::ArcherCategory.create(blank)

                expect(archer_category).to be_invalid
                expect(Organization::ArcherCategory.all.count).to eq(0)

                expect(archer_category.errors.messages[:attr]).to include(default_missing_message)
                # add expect for every required attr (except auto-assign), update error message if using custom
            end

            it "unique attributes are duplicated" do
                # call initial test object to check against for duplication
                test_archer_category
                expect(Organization::ArcherCategory.all.count).to eq(1)
                archer_category = Organization::ArcherCategory.create(duplicate)

                expect(archer_category).to be_invalid
                expect(Organization::ArcherCategory.all.count).to eq(1)
                expect(archer_category.errors.messages[:attr]).to include(default_duplicate_message)
                # add expect for every unique attr, update error message if using custom
            end

            # this is the simple version - can test multiple attrs at same time
            # can combine inclusion and formatting if both simple enough and don't overlap
            it "attributes are outside allowable inputs" do
                duplicate[:attr] = "bad data"
                # add additional invalid data variations to duplicate
                # also see complex version below

                archer_category = Organization::ArcherCategory.create(duplicate)

                expect(archer_category).to be_invalid
                expect(Organization::ArcherCategory.all.count).to eq(0)
                expect(archer_category.errors.messages[:attr]).to include(default_inclusion_message)
                # add expect for every inclusion attr, update error message if using custom
            end

            # this is the simple version - basically same as above, can test multiple attrs at same time
            # can combine inclusion and formatting if both simple enough and don't overlap
            it "attributes are the wrong format" do
                duplicate[:attr] = "bad data"
                # add additional invalid data variations to duplicate
                # also see complex version below

                archer_category = Organization::ArcherCategory.create(duplicate)

                expect(archer_category).to be_invalid
                expect(Organization::ArcherCategory.all.count).to eq(0)
                expect(archer_category.errors.messages[:attr]).to include(default_number_message)
                expect(archer_category.errors.messages[:attr]).to include(default_format_message)
                # add expect for every inclusion attr, update error message if using custom
            end

            # this is the complex version - use for multiple/specific conditions on same attr (inclusion or format)
            it "SPECIFIC ATTR is outside allowable inputs" do
            # it "SPECIFIC ATTR is the wrong format" do
                bad_scenarios = ["value", "value", "value"]
                
                bad_scenarios.each do | test_value |
                    duplicate[:attr] = test_value
                    archer_category = Organization::ArcherCategory.create(duplicate)
                    expect(archer_category).to be_invalid
                    expect(Organization::ArcherCategory.all.count).to eq(0)
                    expect(archer_category.errors.messages[:attr]).to include(default_inclusion_message)
                    # shouldn't need additonal expects - if so break down further
                end
            end
        end
    end

    # association tests ########################################################
    describe "instances are properly associated to other models" do
        before(:each) do
            # load the main test instance (for has many_many only)
            test_archer_category
        end

            #    Find       -->         <replace>
            # Organization::ArcherCategory     --> <actual ModelName for this model> 
            # archer_category    --> <actual model_name for this model>
            # assoc_model_parent    --> <actual model_name for associated parent model>
            # assoc_model_child    --> <actual model_name for for associated child model>

        describe "has many AssocModels and can" do
            it "find an associated object" do
                assoc_assoc_model_child = valid_assoc_model_child
                expect(test_archer_category.assoc_model_childs).to include(assoc_assoc_model_child)
            end

            it "create a new associated object via instance and get associated object attributes" do
                check_assoc_model_child_attrs = {add attrs}
                check_assoc_model_child = test_archer_category.assoc_model_childs.create(check_assoc_model_child_attrs)
                
                expect(test_archer_category.assoc_model_childs).to include(check_assoc_model_child)
                expect(test_archer_category.assoc_model_childs.last.attr).to eq(check_assoc_model_child.attr)
            end
            
            it "re-assign instance via the associated object" do
                assoc_archer_category = valid_archer_category
                assoc_assoc_model_child = valid_assoc_model_child
                
                assoc_assoc_model_child.archer_category = assoc_archer_category
                assoc_assoc_model_child.save

                expect(test_archer_category.assoc_model_childs).not_to include(assoc_assoc_model_child)
                expect(assoc_archer_category.assoc_model_childs).to include(assoc_assoc_model_child)
            end
        end

        describe "belongs to AssocModel and can" do
            it "find an associated object" do
                assoc_assoc_model_parent = valid_assoc_model_parent
                expect(test_assoc_model_child.assoc_model_parent).to eq(assoc_assoc_model_parent)
            end

            it "create a new instance via the associated object and get associated object attributes" do
                assoc_assoc_model_parent = valid_assoc_model_parent
                update[:assoc_model_parent_id] = ""
                check_assoc_model_child = assoc_assoc_model_parent.assoc_model_childs.create(update)
                
                expect(check_assoc_model_child.assoc_model_parent).to eq(assoc_assoc_model_parent)
                expect(check_assoc_model_child.assoc_model_parent.name).to include(assoc_assoc_model_parent.name)
            end
        end
    end

    # helper method tests ########################################################
    describe "all helper methods work correctly:" do
        it "helpers TBD" do
            pending "add as needed"
            expect(test_archer_category).to be_invalid
        end
    end
end
