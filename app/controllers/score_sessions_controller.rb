class ScoreSessionsController < ApplicationController
  helper_method :score_sessions_by_type

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
  end

  def create
  end

  def edit
    @score_session = ScoreSession.find(params[:id])

    # for ScoreSession collections
    @score_session_types = SCORE_SESSION_TYPES
    @gov_bodies = Organization::GovBody.all
    
    # for Round collections
    @round_types = ROUND_TYPES
    @divisions = Organization::Division.all
    @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body
    
  end

  def score
    @score_session = find_active_score_session
  end

  def update
    # binding.pry
    @score_session = ScoreSession.find(params[:id])
    
    @score_session.assign_attributes(score_session_params)
    


    
    # @score_session.rounds.assign_attributes(score_session_params)
    binding.pry
    
    
    # if @score_session.valid?
    if @score_session.save
        # need to update so goes back to correct place (can't use from_score because always comes from edit)
        # redirect_to score_path(@score_session) if from_score
        redirect_to score_session_path(@score_session) # unless from_score
    else
      render :edit
    end
    
    # archer_category
    
    # for round:
      # find archer_category - get input for division and age_class
          # find_category_by_div_age_class(division: params[:round][:division], age_class: params[:round][:age_class])
    
    # for rset:
      # if round.round_type == "Qualifying" then score_method = "Points"
      # if round.round_type == "Match" then score_method = "Set"
      
  end
 
    # user attrs - :round_type, :rank
    # DISCIPLINES = ["Outdoor", "Indoor"]
    # DIVISIONS = ["Recurve", "Compound"]
    # ROUND_TYPES = ["Qualifying", "Match"]


  def score_session_params
    params.require(:score_session).permit(:name, :score_session_type, :gov_body_id, :city, :state, :country, :start_date, :end_date, :rank,
      rounds_attributes: [:id, :round_type, :score_method, :rank, :division, :age_class]
    )
    # params.require(:score_session).permit(:name, :score_session_type, :gov_body_id, :city, :state, :country, :start_date, :end_date, :rank)
  end

  

  # ##### helpers
  def score_sessions_by_type(sessions, type)
    sessions.where(score_session_type: type)
  end

  def score_session_types(sessions)
    sessions.collect { |ss| ss.score_session_type }.uniq
  end

end
