class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:edit, :update, :accept, :ignore]
  
  def create
    @friendship = Friendship.new(user: current_user, friending_id: params[:friending_id])

    if @friendship.save
      flash[:notice] = "Successfully sent a friend invitation"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def accept
    if @friendship.update(accept_friendship_params)
      flash[:notice] = "Success as a friend"
    else
      flash.now[:alert] = @friendship.errors.full_messages.to_sentence
    end
    redirect_to friends_user_path(current_user)
  end

  def ignore
    if @friendship.update(ignore_friendship_params)
      flash[:notice] = "Friend invitation has been ignored"
    else
      flash.now[:alert] = @friendship.errors.full_messages.to_sentence
    end
    redirect_to friends_user_path(current_user)
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def accept_friendship_params
    params[:friendship] = {:accept => true}
    params.require(:friendship).permit(:accept)
  end

  def ignore_friendship_params
    params[:friendship] = {:ignore => true}
    params.require(:friendship).permit(:ignore)
  end

end
