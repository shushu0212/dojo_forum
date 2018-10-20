class CommentsController < ApplicationController
  before_action :set_topic, only: [:create, :destroy]
  
  def create
    @comment = @topic.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
    @topic.update(last_commnet_created_at: @comment.created_at)
    redirect_to topic_path(@topic)
  end

  def destroy
    @comment = Comment.find(params[:id])

    if current_user.admin? || @comment.user.email == current_user.email
      @comment.destroy
      redirect_to topic_path(@topic)
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
