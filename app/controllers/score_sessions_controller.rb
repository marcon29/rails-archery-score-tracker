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
    @score_methods = SCORE_METHODS
    @divisions = Organization::Division.all
    @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body
  end

  def score
    @score_session = find_active_score_session
  end

  def update
    @score_session = ScoreSession.find(params[:id])

    # for ScoreSession collections when re-rendering
    @score_session_types = SCORE_SESSION_TYPES
    @gov_bodies = Organization::GovBody.all
    
    # for Round collections when re-rendering
    @round_types = ROUND_TYPES
    @score_methods = SCORE_METHODS
    @divisions = Organization::Division.all
    @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body
    
    @score_session.assign_attributes(score_session_params)

    # if @score_session.errors[:rounds].first
    
    if @score_session.errors.messages.any?
      @score_session.rounds.each do |round|
        check_children_errors(round, @score_session, :rounds)
      end
      @score_session.valid?
      render :edit
    elsif @score_session.save
        # need to update so goes back to correct place (can't use from_score because always comes from edit)
        # redirect_to score_path(@score_session) if from_score
        binding.pry
        redirect_to score_session_path(@score_session) # unless from_score
    else
      render :edit
    end
      
  end
  
  # round_errors(@score_session)
  
  def check_children_errors(object, parent, children)
    parent_errors = parent.errors[children]
    # if parent_errors.any?
        msg_for = parent_errors.first[object.id]
        msg_for.keys.each do |attr|
          object.errors.add(attr, msg_for[attr].first)
        end
    # end
end
 
    # user attrs - :round_type, :rank
    # DISCIPLINES = ["Outdoor", "Indoor"]
    # DIVISIONS = ["Recurve", "Compound"]
    # ROUND_TYPES = ["Qualifying", "Match"]


  def score_session_params
    params.require(:score_session).permit(:name, :score_session_type, :gov_body_id, :city, :state, :country, :start_date, :end_date, :rank,
      # rounds_attributes: [:id, :round_type, :score_method, :rank, :division, :age_class]
      rounds_attributes: [:id, :round_type, :score_method, :rank, :division, :age_class, 
        rsets_attributes: [:id, :date, :rank]
      ]
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
