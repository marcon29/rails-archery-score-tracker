class StaticController < ApplicationController
  def home
    @user = Archer.new
  end

  def about
  end
end
