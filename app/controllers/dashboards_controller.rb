class DashboardsController < RestrictedAccessController
  def show
    @profiles = Profile.page(params[:page]).per(3)
  end
end
