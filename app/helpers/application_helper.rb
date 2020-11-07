module ApplicationHelper
    FORM_NOTES = {
        new: {
            comp_section: "You can change these at any time.", 
            age_class: "If you don't choose, the youngest eligible age class will be automatically assigned (requires you enter your birth date)."
        }, 
        edit: {
            password: "Leave blank if you are not changing your password.", 
            comp_section: "Used to reduce entering info when starting new Score Session.", 
            age_class: "Only shows Age Classes you're eligible for."
        }
    }
    
    def error_check(object, attr)
        if object.errors[attr].any?
            tag.p object.errors[attr].first, class: "small-text red-text" 
        else
            tag.br
        end
    end

    def form_type
        if params[:action] == "new" || params[:action] == "create"
            "new"
        elsif params[:action] == "edit" || params[:action] == "update" 
            "edit" 
        end
    end

    def form_note(placement)
        if form_type == "new"
            tag.p FORM_NOTES[:new][placement], class: "small-text" 
        elsif form_type == "edit"
            tag.p FORM_NOTES[:edit][placement], class: "small-text" 
        end
    end


    # ##########################################################
    # these might be better in a model
    # ##########################################################
    def active_score_session?
        current_user.score_sessions.any? && current_user.score_sessions.last.active
    end
    
    def formatted_date(date)
        date.strftime("%B%e, %Y")
    end

    # adding this also - may want to use when displaying ScoreSession instead of long format above
    # delete if don't use
    def formatted_date_short(date)
        date.strftime("%m/%d/%Y")
    end

    def formatted_date_range(start_date, end_date)
        range = start_date.strftime("%m/%d/%Y")
        if end_date != start_date
            range = range + "-" + end_date.strftime("%m/%d/%Y") 
        end
        range
    end


end
