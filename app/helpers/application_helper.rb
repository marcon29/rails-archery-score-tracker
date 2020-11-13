module ApplicationHelper
    FORM_NOTES = {
        new: {
            comp_section: "You can change these at any time.", 
            default_age_class: "If you don't choose, the youngest eligible age class will be automatically assigned (requires you enter your birth date).", 
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
     
    def get_child_error(children, object, attr)
        check_object = object
        children.each do |child|
            check_object = child if child.id == object.id
        end
        object.errors.messages[attr] = check_object.errors.messages[attr]
    end

    def selected_option(object, attr, id_or_value)
        if new_action?
            nil
        else
        end
    end

    def home_action?
        params[:action] == "home"
    end

    def show_action?
        params[:action] == "show"
    end

    def new_action?
        params[:action] == "new"
    end

    def create_action?
        params[:action] == "create"
    end

    def edit_action?
        params[:action] == "edit"
    end

    def score_action?
        params[:action] == "score" || action_name == "score"
    end

    # def from_score_session?
    #     params[:controller] == "score_sessions"
    # end

    # these handle re-rendering the form so it displays the correct info
    # def from_new?
    #     request.referrer && request.referrer.ends_with?("new")
    # end
    
    # def from_edit?
    #     request.referrer && request.referrer.ends_with?("edit")
    # end

    def from_score?
        request.referrer && request.referrer.ends_with?("score")
    end

    def from_direct_url_entry?
        !request.referrer
    end

    def get_rank(object)
        object.rank.blank? ? "N/A" : object.rank
    end

    def required_field
        tag.span "*", class: "red-text"
    end


    # ##########################################################
    # these might be better in a model
    # ##########################################################
    def active_score_session?
        current_user.score_sessions.any? && current_user.score_sessions.last.active
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
