class ArchersController < ApplicationController
  def show
  end

  def new
    @archer = Archer.new
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = Organization::AgeClass.all
  end
  # <%= f.text_field :gender, class: "form-input-field archer-input", placeholder: (@archer.errors[:password].first || "Select your gender *") %>
  # <%= f.text_field :default_age_class, class: "form-input-field archer-input", placeholder: (@archer.errors[:password].first || "Select your primary competitive age class") %>
  # <%= f.text_field :default_division, class: "form-input-field archer-input", placeholder: (@archer.errors[:password].first || "Select your primary shooting style *") %>

  


  def create
    @archer = Archer.new
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = Organization::AgeClass.all
    
    check = params[:archer]
    render :new
  end

  def edit
    @archer = current_user
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = Organization::AgeClass.all
  end

  def update
    @archer = current_user
    @genders = Organization::Gender.all
    @divisions = Organization::Division.all
    @age_classes = Organization::AgeClass.all

    check = params[:archer]
    render :edit
  end

  
end
