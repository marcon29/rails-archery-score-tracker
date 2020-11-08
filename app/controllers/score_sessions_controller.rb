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
    @round = @score_session.rounds.first


    @score_session_types = SCORE_SESSION_TYPES
    @gov_bodies = Organization::GovBody.all
    @round_types = ROUND_TYPES
    @divisions = Organization::Division.all
    # @age_classes = Organization::AgeClass.all # linit by ScoreSession.gov_body
    @age_classes = current_user.eligible_age_classes
  end

  def score
    @score_session = find_active_score_session
  end

  def update
    binding.pry
    # for Round:
      # if round_type == "Qualifying" then score_method = "Points"
      # if round_type == "Match" then score_method = "Set"
      # find archer_category - get input for division and age_class
          # find_category_by_div_age_class(division: params[:round][:division], age_class: params[:round][:age_class])
  end
 
    # user attrs - :round_type, :rank
    # DISCIPLINES = ["Outdoor", "Indoor"]
    # DIVISIONS = ["Recurve", "Compound"]
    # ROUND_TYPES = ["Qualifying", "Match"]

  # ##### helpers
  def score_sessions_by_type(sessions, type)
    sessions.where(score_session_type: type)
  end

  def score_session_types(sessions)
    sessions.collect { |ss| ss.score_session_type }.uniq
  end

end
