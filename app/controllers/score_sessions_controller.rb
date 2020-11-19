class ScoreSessionsController < ApplicationController
    helper_method :score_sessions_by_type
    before_action :get_ss_round_form_collections, only: [:new, :create, :edit, :update]
    before_action :get_rset_form_collections, only: [:new, :create]

    # don't forget to restrict the views!!!!!

    def index
        @score_sessions = current_user.score_sessions
        @score_session_types = score_session_types(@score_sessions)
    end
  
    def show
        @score_session = ScoreSession.find(params[:id])
        @rounds = @score_session.rounds
    end
  
    def new
        @score_session = ScoreSession.new(archer: current_user)
        @score_session.rounds.build(archer: @score_session.archer)
    end
  
    def create
        # should just be able to use this after nesting resources, below is just to get things working
        # @score_session = ScoreSession.new(score_session_params)

        @score_session = ScoreSession.new(archer: current_user)
        @score_session.assign_attributes(score_session_params)

        if @score_session.errors.any?
            render :new
        else
            redirect_to score_session_path(@score_session) # unless from_score
        end
    end
  
    def edit
        @score_session = ScoreSession.find(params[:id])
    end
  
    def update
        @score_session = ScoreSession.find(params[:id])
        @score_session.assign_attributes(score_session_params)

        assign_errors_to_all_children(@score_session.rsets, @score_session, :rsets)
        assign_errors_to_all_children(@score_session.rounds, @score_session, :rounds)

        binding.pry

        if @score_session.errors.any?
            render :edit
        else
            @score_session.save
            auto_update_children_names
                # need to update so goes back to correct place (can't use from_score because always comes from edit)
                # redirect_to score_path(@score_session) if from_score
            redirect_to score_session_path(@score_session) # unless from_score
        end
    end
  
    def score
        @score_session = find_active_score_session
    end
  
    def update_score
        # if params[:end]
        @endd = End.find(end_params[:id])
        @score_session = @endd.score_session
        @rset = @endd.rset

        @endd.assign_attributes(end_params)

        if @endd.errors.any? #|| @rset.errors.any?
            @endd.errors[:shots].each do |id_error|
                id_error.each do |num, error|
                    params[:end][:shots_attributes]["#{num-1}"][:errors] = error
                end
            end
            @endd.errors.delete(:shots)
            params[:end][:errors] = @endd.errors.messages
            render :score
        else
            @endd.save
            if @score_session.complete?
                @score_session.update(active: false) 
                redirect_to score_session_path(@score_session)
            else
                redirect_to score_path(@score_session)
            end
        end
        # end
    end

    def update_score_rset
        # if params[:rset]
        @rset = Rset.find(rset_params[:id])
        @score_session = @rset.score_session
        
        if @rset.update(rset_params)
            redirect_to score_path(@score_session)
        else
            params[:rset][:errors] = @rset.errors.messages
            render :score
        end
        # end
    end
    
  
    def score_session_params
        params.require(:score_session).permit(
            :name, :score_session_type, :gov_body_id, :city, :state, :country, :start_date, :end_date, :rank, :round_format, 
            rounds_attributes: [:id, :round_format_id, :round_type, :score_method, :rank, :division, :age_class], 
            rsets_attributes: [:id, :date, :rank]
        )
    end

    def rset_params
        params.require(:rset).permit(:id, :date, :rank)
    end
  
    def end_params
        params.require(:end).permit(:id, :set_score, shots_attributes: [:id, :score_entry])
    end
  
    # ##### helpers
    def get_ss_round_form_collections
        # for ScoreSession collections
        @score_session_types = SCORE_SESSION_TYPES
        @gov_bodies = Organization::GovBody.all
        
        # for Round collections
        @round_types = ROUND_TYPES
        @score_methods = SCORE_METHODS
        @divisions = Organization::Division.all
        @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body
        @default_division = Organization::Division.find_by(name: current_user.default_division)
        @default_age_class = Organization::AgeClass.find_by(name: current_user.default_age_class)
    end

    def get_rset_form_collections
        @round_formats = Format::RoundFormat.all
    end

    def score_sessions_by_type(sessions, type)
        sessions.where(score_session_type: type).where(active: false)
    end
  
    def score_session_types(sessions)
        sessions.collect { |ss| ss.score_session_type }.uniq
    end
    
    def assign_errors_to_all_children(child_collection, parent, children_symbol)
        child_collection.each do |child|
            assign_errors_to_child(child, parent, children_symbol)
        end
    end
    
    def assign_errors_to_child(child, parent, children_symbol)
        parent.errors[children_symbol].each do |id_error|
            error = id_error[child.id]
            if error
                error.keys.each do |attr|
                    child.errors.add(attr, error[attr].first) if error[attr].present?
                end
            end
        end
    end

    def auto_update_children_names
        @score_session.rounds.each { |round| round.update(name: "") }
        @score_session.rsets.each { |rset| rset.update(name: "") }
    end

  

    
  end
  