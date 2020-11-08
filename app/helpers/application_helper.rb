module ApplicationHelper
    FORM_NOTES = {
        new: {
            comp_section: "You can change these at any time.", 
            age_class: "If you don't choose, the youngest eligible age class will be automatically assigned (requires you enter your birth date).", 
            end_date: "Leave blank if score session is single day.", 
            rank: 'Leave blank unless entering an old score session. Otherwise enter a number above 0, "W" or "L".'
        }, 
        edit: {
            password: "Leave blank if you are not changing your password.", 
            comp_section: "Used to reduce entering info when starting new Score Session.", 
            age_class: "Only shows Age Classes you're eligible for.", 
            end_date: "Leave blank if score session is single day.", 
            rank: 'Enter a number above 0, "W" or "L".'
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

    def home_action?
        params[:action] == "home"
    end

    def show_action?
        params[:action] == "show"
    end

    def edit_action?
        params[:action] == "edit"
    end

    

    def form_note(placement)
        if form_type == "new"
            tag.p FORM_NOTES[:new][placement], class: "small-text" 
        elsif form_type == "edit"
            tag.p FORM_NOTES[:edit][placement], class: "small-text" 
        end
    end

    # display_rank(rset)

    def get_rank(object)
        object.rank.blank? ? "N/A" : object.rank
    end


    # ##########################################################
    # these might be better in a model
    # ##########################################################
    def active_score_session?
        current_user.score_sessions.any? && current_user.score_sessions.last.active
    end
    
    def formatted_date(date)
        date.strftime("%m/%d/%Y")
    end

    def formatted_date_long(date)
        date.strftime("%B%e, %Y")
    end

    def formatted_date_range(start_date, end_date)
        range = formatted_date(start_date)
        if end_date != start_date
            range = range + "-" + formatted_date(end_date)
        end
        range
    end


end
