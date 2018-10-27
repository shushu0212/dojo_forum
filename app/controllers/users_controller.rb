class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  before_action :authenticate_current_user, only: [:edit, :update, :drafts, :friends]

  def show
    @posts = @user.topics.where(publish:true)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "profile was successfully updated"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "profile was failed to update"
      render :edit
    end
  end

  def comments
    @comments = @user.comments
  end

  def collects
    @collects = @user.collects
  end

  def drafts
    @posts = @user.topics.where(publish:false)
  end

  def friends
    @waiting_friendings = @user.waiting_friendings
    @waiting_frienders = @user.waiting_frienders
    @friends = @user.all_friends
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end

  def authenticate_current_user
    unless @user == current_user
      flash[:alert] = "非本人，沒有權限!"
      redirect_to root_path
    end
  end

end
