class Admin::ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  def show
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to [:admin, @profile], notice: 'Profile was successfully created.'
    else
      render :new, alert: 'Profile could not be created.'
    end
  end

  def update
    if @profile.update(profile_params)
      redirect_to [:admin, @profile], notice: 'Profile was successfully updated.'
    else
      render :edit, alert: 'Profile could not be updated.'
    end
  end

  def destroy
    @profile.destroy
    redirect_to dashboard_path, notice: 'Profile was successfully destroyed.'
  end

  private
  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :date_of_birth, :gender, :city, :country, :nationality, :date_of_disappearance, :city_of_disappearance, :country_of_disappearance, :found, images: [])
  end
end