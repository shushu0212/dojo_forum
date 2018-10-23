class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:edit, :update]
  
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

  def update
    byebug
    # if params[:commit] == "Accept"
      @friendship.accept = true
      if @friendship.update(friendship_params)
        flash[:notice] = "Success as a friend"
      else
        flash.now[:alert] = @friendship.errors.full_messages.to_sentence 
      end
      redirect_to friends_user_path
    # else
    #   @friendship.ignore = true
    #   if @friendship.update(friendship_params)
    #     flash[:notice] = "Friend invitation has been ignored"
    #   else
    #     flash.now[:alert] = @friendship.errors.full_messages.to_sentence 
    #   end
    # end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:accept, :ignore)
  end

end
