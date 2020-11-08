class ApplicationController < ActionController::Base
    # protect_from_forgery with: :exception
    helper_method :current_user, :find_active_score_session

    def log_user_in(user)
        session[:user_id] = user.id
        redirect_to root_path
    end

    def current_user
        @current_user ||= Archer.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
        !!current_user
    end

    def require_login
        redirect_to root_path unless logged_in?
    end

    def find_active_score_session
        current_user.score_sessions.where(active: true).first
    end

    def score_session_types(sessions)
        sessions.collect { |ss| ss.score_session_type }.uniq
    end
end
