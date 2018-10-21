class CommentsController < ApplicationController
  before_action :set_topic, only: [:create, :destroy, :edit, :update, :update_comment]
  before_action :set_comment, only: [:destroy, :edit, :update, :update_comment]
  
  def create
    @comment = @topic.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
    @topic.update(last_commnet_created_at: @comment.created_at)
    redirect_to topic_path(@topic)
  end

  def destroy
    if current_user.admin? || @comment.user.email == current_user.email
      @comment.destroy
      redirect_to topic_path(@topic)
    end
  end

  def edit
    unless @comment.user == current_user
      flash[:alert] = "非本人，無法編輯!"
      redirect_to topic_path(@topic)
    end
  end

  def update
    if @comment.update(comment_params)
      @topic.update(last_commnet_created_at: @comment.created_at)
      flash[:notice] = "comment was successfully updated"
      redirect_to topic_path(@topic)
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
      render :edit
    end
  end

  def update_comment
    if @comment.update(comment_params)
      @topic.update(last_commnet_created_at: @comment.created_at)
      flash[:notice] = "comment was successfully updated"
      redirect_to topic_path(@topic)
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
