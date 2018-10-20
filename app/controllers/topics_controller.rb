class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  def index
    if params[:order_by] == 'lr'
      @topics = Topic.page(params[:page]).order(last_commnet_created_at: :desc).per(20)
    elsif params[:order_by] == 'vc'
      @topics = Topic.page(params[:page]).order(viewed_count: :desc).per(20)
    elsif params[:order_by] == 'rc'
      @topics = Topic.page(params[:page]).order(comments_count: :desc).per(20)
    else
      @topics = Topic.page(params[:page]).per(20)
    end
  end

  def show
    @topic.viewed_count += 1
    @topic.save!
    @topic_comments = @topic.comments.page(params[:page]).per(20)
    @comment = Comment.new
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if params[:commit] == "Save Draft"
      @topic.publish = false
      if @topic.save
        flash[:notice] = "draft was successfully saved"
        redirect_to root_path
      else
        flash.now[:alert] = "draft was failed to save"
        render :new
      end
    else
      if @topic.save
        flash[:notice] = "topic was successfully created"
        redirect_to root_path
      else
        flash.now[:alert] = "topic was failed to create"
        render :new
      end
    end
  end

  def edit
    unless @topic.user == current_user
      flash[:alert] = "非本人文章，無法編輯!"
      redirect_to root_path
    end
  end

  def update
    if params[:commit] == "Save Draft"
      @topic.publish = false
      if @topic.update(topic_params)
        flash[:notice] = "draft was successfully saved"
        redirect_to root_path
      else
        flash.now[:alert] = "draft was failed to save"
        render :new
      end
    else
      @topic.publish = true
      if @topic.update(topic_params)
        flash[:notice] = "topic was successfully updated"
        redirect_to topic_path
      else
        flash.now[:alert] = "topic was failed to update"
        render :edit
      end
    end
  end

  def destroy
    if @topic.destroy
      flash[:alert] = "topic was successfully deleted"
    else
      flash[:alert] = @topic.errors.full_messages.to_sentence
    end
    redirect_to root_path
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :viewed_count, :audience_id, category_ids: [])
  end
end
