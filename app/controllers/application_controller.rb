class ApplicationController < ActionController::Base
    # protect_from_forgery with: :exception
    helper_method :current_user

    

    def log_user_in(user)
        # real code
        session[:user_id] = user.id
        redirect_to root_path

        # logs in Senior Archer with active, unscored tournament
        # session[:user_id] = 5

        # logs in Junior Archer with inactive, finished tournament
        # session[:user_id] = 4
    end

    def current_user
        # real code
        @current_user ||= Archer.find(session[:user_id]) if session[:user_id]

        # logs in Senior Archer with active, unscored tournament
        # @current_user ||= Archer.find(5)

        # logs in Junior Archer with inactive, finished tournament
        # @current_user ||= Archer.find(4)
    end

    def logged_in?
        !!current_user
    end

    def require_login
        redirect_to login_path unless logged_in?
    end
end
