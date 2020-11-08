class StaticController < ApplicationController
  def home
    @user = Archer.new
    @active_score_session = find_active_score_session
  end

  def about
  end
end
