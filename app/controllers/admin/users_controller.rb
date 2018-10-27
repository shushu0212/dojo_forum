class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_user, only: [:update]

  def index
    @users = User.all.order(:id)
  end

  def update
    if @user.update(user_params_role)
      redirect_to admin_users_path
      flash[:notice] = "user's role was successfully updated"
    else
      @users = User.all
      render :index
    end
  end

  private

  def authenticate_admin
    unless current_user.admin?
      flash[:alert] = "Not allow!"
      redirect_to root_path
    end
  end

  def set_user 
    @user = User.find(params[:id])
  end

  def user_params_role
    params.require(:user).permit(:role_id)
  end
end
