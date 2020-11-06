class ArchersController < ApplicationController
  def show
  end

  def new
    @archer = Archer.new
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = Organization::AgeClass.all
  end

  def create
    @archer = Archer.new(archer_params)
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = Organization::AgeClass.all

    if @archer.save
      log_user_in(@archer)
    else
      render :new
    end
  end

  def edit
    @archer = current_user
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = @archer.eligible_age_classes
    
  end

  def update
    @archer = current_user
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = @archer.eligible_age_classes

    
    @archer.assign_attributes(archer_params)
    
    if !@archer.eligible_age_classes.include?(Organization::AgeClass.find_by(name: params[:archer][:default_age_class]))
      @archer.default_age_class = nil
    end

    if @archer.save
      redirect_to archer_path(@archer)
    else
      render :edit
    end
  end


  def archer_params
    params.require(:archer).permit(
      :username, 
      :email, 
      :password, 
      :first_name, 
      :last_name, 
      :birthdate, 
      :gender_id, 
      :home_city, 
      :home_state, 
      :home_country, 
      :default_age_class, 
      :default_division
    )
  end



  
end
