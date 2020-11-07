class ScoreSessionsController < ApplicationController

  # don't forget to restrict the views!!!!!

  def index
    # real code
    # @score_sessions = current_user.score_sessions

    # placeholder to get view set up
    @score_sessions = current_user.score_sessions.first
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
  end

  def update
  end

  

end
