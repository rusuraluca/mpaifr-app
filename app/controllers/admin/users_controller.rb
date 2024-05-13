class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.page(params[:page]).per(2)
  end

  def assign_role
    @user = User.find(params[:id])
    @roles = Role.all
  end

  def update_role
    user = User.find(params[:id])
    user.roles.delete_all
    params[:roles].each do |role|
      user.add_role(role)
    end if params[:roles].present?
    redirect_to admin_users_path, notice: 'Roles updated successfully.'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end

  private

  def require_admin
    unless current_user.has_role?(:admin)
      redirect_to root_path, alert: 'Unauthorized access!'
    end
  end
end
