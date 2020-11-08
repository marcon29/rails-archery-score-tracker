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
    @score_session_types = SCORE_SESSION_TYPES
    @gov_bodies = Organization::GovBody.all
  end

  def score
    @score_session = find_active_score_session
  end

  def update
  end


  # ##### helpers
  def score_sessions_by_type(sessions, type)
    sessions.where(score_session_type: type)
  end

  def score_session_types(sessions)
    sessions.collect { |ss| ss.score_session_type }.uniq
  end

end
