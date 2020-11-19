module ApplicationHelper
    FORM_NOTES = {
        new: {
            comp_section: "You can change these at any time.", 
            default_age_class: "If you don't choose, the youngest eligible age class will be automatically assigned (requires you enter your birth date).", 
            age_class: "Only shows eligible age classes.", 
            end_date: "Leave blank if score session is single day.", 
            rank: 'Leave blank unless entering an old score session. Otherwise enter a number above 0, "W" or "L".'
        }, 
        edit: {
            password: "Leave blank if you are not changing your password.", 
            comp_section: "Reduces entering info when starting new score session.", 
            default_age_class: "Only shows eligible age classes.", 
            age_class: "Only shows eligible age classes.", 
            end_date: "Leave blank or use start date if score session is single day.", 
            rank: 'Enter a number above 0, "W" or "L".'
        }
    }

    def form_note(placement)
        if form_type == "new" && FORM_NOTES[:new][placement]
            tag.p FORM_NOTES[:new][placement], class: "small-text remove-bottom-margin"
        elsif form_type == "edit" && FORM_NOTES[:edit][placement]
            tag.p FORM_NOTES[:edit][placement], class: "small-text remove-bottom-margin"
        end
    end

    def form_type
        if params[:action] == "new" || params[:action] == "create"
            "new"
        elsif params[:action] == "edit" || params[:action] == "update" 
            "edit" 
        end
    end

    def form_input_class(placement)
        "remove-bottom-margin" if form_note(placement)
    end

    def error_check(object, attr)
        if object.errors[attr].any?
            tag.p object.errors[attr].first, class: "small-text red-text"
        end
    end

    def add_error_or_note(object, attr)
        if object.errors[attr].any?
            tag.p object.errors[attr].first, class: "small-text red-text"
        else
            form_note(attr)
        end
    end

    def assign_rset_errors(rset)
        if params[:rset] && params[:rset][:id].to_i == rset.id
            params[:rset][:errors].each { |attr, err| rset.errors.add(attr, err.first) } if params[:rset][:errors].present?
        end
    end

    def assign_end_errors(endd)
        if params[:end]
            endd.shots.each do |shot|
                errors = params[:end][:shots_attributes]["#{shot.number-1}"][:errors]
                errors.each { |attr, err| shot.errors.add(attr, err.first) } if errors
            end
            params[:end][:errors].each { |attr, err| endd.errors.add(attr, err.first) } if params[:end][:errors].present?
        end
    end

    def end_or_shot_errors?(endd)
        shots_with_errors = endd.shots.select { |shot| shot.errors.any? }
        shots_with_errors.present? || endd.errors.any?
    end
     
    def get_child_error(children, object, attr)
        check_object = object
        children.each do |child|
            check_object = child if child.id == object.id
        end
        object.errors.messages[attr] = check_object.errors.messages[attr]
    end

    # ---------------------------

    def home_action?
        params[:action] == "home"
    end
   
    def show_action?
        params[:action] == "show"
    end

    def creation_functionality?
        action_name == "new" || action_name == "create" 
    end

    def new_action?
        params[:action] == "new"
    end

    def update_functionality?
        action_name == "edit" || action_name == "update" 
        # (action_name == "edit" || action_name == "update") && !from_score?
    end

    def archer_functionality?
        controller_name == "archers"
    end

    def score_session_functionality?
        controller_name == "score_sessions" && !score_functionality?
    end

    def round_functionality?
        controller_name == "rounds"
    end

    def score_functionality?
        action_name == "score" || action_name == "update_score" || action_name =="update_score_rset"
    end

    # ---------------------------

    # these handle re-rendering the form so it displays the correct info
    def from_new?
        request.referrer && request.referrer.ends_with?("new")
    end
    
    def from_edit?
        request.referrer && request.referrer.ends_with?("edit")
    end

    def from_score?
        request.referrer && request.referrer.ends_with?("score")
    end

    def from_direct_url_entry?
        !request.referrer
    end

    # ---------------------------

    def get_rank(object)
        object.rank.blank? ? "N/A" : object.rank
    end

    def required_field
        tag.span "*", class: "red-text"
    end

    def display_score_session_name(object)
        text = object.name
        path = score_session_path(object)
        
        text << " (Scoring)" if score_functionality?
        path = score_path(object) if home_action?
        
        if show_action? || score_functionality?
            tag.h1 text, class: "short-bottom-margin display-horiz-hl"
        else
            tag.h3 (link_to text, path), class: "short-bottom-margin"
        end
    end

    def display_detail(label_text, first_detail, second_detail=nil, parentheses=nil)
        label = label_text + ": " if label_text

        details = tag.b do
            concat first_detail
            concat " " if second_detail
            concat "(" if parentheses
            concat second_detail if second_detail
            concat ")" if parentheses
        end

        class_selector = "display-horiz"
        class_selector = nil if archer_functionality?

        tag.p class: class_selector do
            concat label
            concat details
        end
    end

    def display_edit_link(object)
        link_text = "Edit"
        link_text << " #{object.class.name.titlecase} Details" if score_functionality?
        link_text << " Profile" if object.class.name == "Archer"
        
        path = edit_score_session_path(object) if object.class.name == "ScoreSession"
        path = edit_round_path(object) if object.class.name == "Round"
        path = edit_archer_path(object) if object.class.name == "Archer"

        tag.p (link_to link_text, path), class: "display-horiz"
    end

    def build_input_label(builder_object, attr, required=nil)
        label_text = "#{attr}".titlecase
        label_text = "Primary Shooting Style" if attr == :default_division
        label_text = "Primary Age Class" if attr == :default_age_class

        label = builder_object.label attr do
          concat label_text  
          concat required_field if required
        end
    end

    def build_label_field_pair(builder_object, input_field, object, attr, required)
        tag.div class: "label-field-pair" do
            concat build_input_label(builder_object, attr, required)
            concat input_field
            concat add_error_or_note(object, attr)
        end
    end

    def build_form_input(builder_object, input_type, attr, object, placeholder=nil, required=nil)
        if input_type == "text"
            input_field = builder_object.text_field attr, class: form_input_class(attr), placeholder: placeholder
        elsif input_type == "date"
            input_field = builder_object.date_field attr, class: form_input_class(attr)
        elsif input_type == "email"
            input_field = builder_object.email_field attr, class: form_input_class(attr)
        elsif input_type == "password"
            input_field = builder_object.password_field attr, class: form_input_class(attr)
        end

        build_label_field_pair(builder_object, input_field, object, attr, required)
    end

    def build_form_collection(builder_object, input_type, attr, object, collection, identifier=nil, selected_item=nil, required=nil)
        if input_type == "models"
            # this causes error on Archer#new form
            # input_field = builder_object.collection_select attr, collection, identifier, :name, {selected: selected_item}, {class: form_input_class(attr)}

            # this does not cause error on Archer#new form - see if screws up selected item in other places
            input_field = builder_object.collection_select attr, collection, identifier, :name, {}, {class: form_input_class(attr)}

        elsif input_type == "list_items"
            input_field = builder_object.select attr, options_for_select(collection, selected_item), {}, class: form_input_class(attr)
        end
        
        build_label_field_pair(builder_object, input_field, object, attr, required)
    end

    def display_required_note
        tag.p do
            concat "Fields marked with a "
            concat required_field
            concat " are required."
        end
    end

    def display_form_cancel_link(object)
        if archer_functionality?
            path = archer_path(object)
        elsif score_session_functionality? && update_functionality?
            path = score_session_path(object) if !object.active
            path = score_path(object) if object.active
        elsif round_functionality?
            path = score_path(object)
        elsif request.referer.present?
            path = request.referer
        else
            path = score_sessions_path
        end
        
        tag.p link_to "Cancel", path
    end


    # ##########################################################
    # these might be better in a model
    # ##########################################################
    def active_score_session?
        # current_user.score_sessions.any? && current_user.score_sessions.last.active
        current_user.score_sessions.where(active: true).first
    end
    
    def formatted_date(date)
        date.strftime("%m/%d/%Y") if date
    end

    def formatted_date_long(date)
        date.strftime("%B%e, %Y") if date
    end

    def formatted_date_range(start_date, end_date)
        range = formatted_date(start_date)
        if end_date != start_date
            range = range + "-" + formatted_date(end_date)
        end
        range
    end


end
