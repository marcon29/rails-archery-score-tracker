class RoundsController < ApplicationController

  # don't forget to restrict the views!!!!!

  def edit
    @round = Round.find(params[:id])
    @score_session = @round.score_session

    # for Round collections when re-rendering
    @round_formats = Format::RoundFormat.all
    @round_types = ROUND_TYPES
    @score_methods = SCORE_METHODS
    @divisions = Organization::Division.all
    @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body
  end

  def update
    @round = Round.find(params[:id])
    @score_session = @round.score_session
    
    # for Round collections when re-rendering
    @round_formats = Format::RoundFormat.all
    @round_types = ROUND_TYPES
    @score_methods = SCORE_METHODS
    @divisions = Organization::Division.all
    @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body

    attrs = round_params
    attrs[:archer_category_id] = @round.find_category_by_div_age_class(division: attrs[:division], age_class: attrs[:age_class]).id
    attrs.delete(:division)
    attrs.delete(:age_class)
    @round.assign_attributes(attrs)

    if @round.save
      # update children for dependent data
      @round.rsets.each { |rset| rset.update(distance_target_category: nil) }
      redirect_to score_path(@score_session)
    else
      render :edit
    end
  end

  def round_params
    params.require(:round).permit(:round_type, :score_method, :rank, :division, :age_class)
  end
end
