class FriendshipsController < ApplicationController
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
end
