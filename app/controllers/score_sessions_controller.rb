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
    @score_session = ScoreSession.new(archer: current_user)
    @score_session.rounds.build(archer: @score_session.archer)
    # assoc to archer, gov_body

    # don't need rank for anything - this is for SS that haven't been shot yet
    
    # data needed for Round
        # round_format
        # division, age_class (for archer_category)
        # round_type, score_method
    
    # selects RoundFormat
      # RoundFormat creates Round (assoc to archer, score_session, round_format, archer_category)
      # iterate through RoundFormat.SetEndFormats
          # for each: 
              # creates Rset (assoc to archer, score_session, round, set_end_format)
                  # no data needed: name auto-assigned, date & rank are update only
                  # dtc auto assoc every time Rset validated
              # Rset.set_end_format.num_ends times create endd (assoc to archer, score_session, round, rset)
                  # no data needed: number auto-assigned, set_score is score only
                  # iterate through rset.ends
                      # for each:
                          # rset.set_end_format.shots_per_end times create shot (assoc to archer, score_session, round, rset, endd)
                              # no data needed: number auto-assigned, score_entry is score only
    
    
    # for Round and Rset creation
    @round_formats = Format::RoundFormat.all

    

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

  def create
    # @score_session = ScoreSession.assign_attributes(score_session_params)
    binding.pry

    redirect_to new_score_session_path
    
    # if @score_session.save
    #   redirect_to score_session_path(@score_session) # unless from_score
    # else
    #   render :new
    # end
  end

  def edit
    @score_session = ScoreSession.find(params[:id])

    # for ScoreSession collections
    @score_session_types = SCORE_SESSION_TYPES
    @gov_bodies = Organization::GovBody.all
    
    # for Round collections
    @round_formats = Format::RoundFormat.all
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
# binding.pry # 1

    @score_session.assign_attributes(score_session_params)
# binding.pry # 17

    @score_session.rsets.each do |rset|
      check_children_errors(rset, @score_session, :rsets)
    end
    
    @score_session.rounds.each do |round|
      check_children_errors(round, @score_session, :rounds)
    end
# binding.pry # 18

    if @score_session.errors.any?
# binding.pry # 21
      render :edit
    elsif @score_session.save
      children_auto_updates
        # need to update so goes back to correct place (can't use from_score because always comes from edit)
        # redirect_to score_path(@score_session) if from_score
        redirect_to score_session_path(@score_session) # unless from_score
    else
      render :edit
    end
  end

  def score_session_params
    params.require(:score_session).permit(
      :name, :score_session_type, :gov_body_id, :city, :state, :country, :start_date, :end_date, :rank, :round_format, 
      rounds_attributes: [:id, :round_format_id, :round_type, :score_method, :rank, :division, :age_class], 
      rsets_attributes: [:id, :date, :rank]
    )
  end

  

  # ##### helpers
  def score_sessions_by_type(sessions, type)
    sessions.where(score_session_type: type)
  end

  def score_session_types(sessions)
    sessions.collect { |ss| ss.score_session_type }.uniq
  end

  def children_auto_updates
    @score_session.rounds.each { |round| round.update(name: "") }
    @score_session.rsets.each { |rset| rset.update(name: "") }
  end
  
  def check_children_errors(object, parent, children_symbol)
    parent.errors[children_symbol].each do |id_error|
      error = id_error[object.id]
      if error
        error.keys.each do |attr|
            object.errors.add(attr, error[attr].first)
        end
      end
    end
  end

end
