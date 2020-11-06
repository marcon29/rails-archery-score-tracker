module ApplicationHelper
    
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

    
end
