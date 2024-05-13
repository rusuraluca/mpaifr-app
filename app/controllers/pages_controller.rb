class PagesController < ApplicationController
  before_action :check_signed_in

  def home
  end

  private

  def check_signed_in
    redirect_to(dashboard_path) if signed_in?
  end
end
