class RoundsController < ApplicationController
  before_action :get_round_form_collections, only: [:edit, :update]
  # don't forget to restrict the views!!!!!

  def edit
    @round = Round.find(params[:id])
    @score_session = @round.score_session
    redirect_to score_path(@score_session) if !request.referrer
  end

  def update
    @round = Round.find(params[:id])
    @score_session = @round.score_session

    attrs = round_params
    attrs[:archer_category_id] = @round.find_category_by_div_age_class(division: attrs[:division], age_class: attrs[:age_class]).id
    attrs.delete(:division)
    attrs.delete(:age_class)
    @round.assign_attributes(attrs)

    if @round.save
      @round.rsets.each { |rset| rset.update(distance_target_category: nil) }
      redirect_to score_path(@score_session)
    else
      render :edit
    end
  end

  def round_params
    params.require(:round).permit(:round_type, :score_method, :rank, :division, :age_class)
  end
  
  def get_round_form_collections
    @round_formats = Format::RoundFormat.all
    @round_types = ROUND_TYPES
    @score_methods = SCORE_METHODS
    @divisions = Organization::Division.all
    @age_classes = current_user.eligible_age_classes # linit by ScoreSession.gov_body
  end
end
