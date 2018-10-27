class TopicsController < ApplicationController
  before_action :set_topic, except: [:index, :new, :create, :feeds]
  before_action :authenticate_user!, except: :index
  before_action :authenticate_current_user, only: [:edit, :update]

  def index
    if params[:order_by] == 'lr'
      @topics = Topic.page(params[:page]).order(last_commnet_created_at: :desc).per(20)
    elsif params[:order_by] == 'vc'
      @topics = Topic.page(params[:page]).order(viewed_count: :desc).per(20)
    elsif params[:order_by] == 'rc'
      @topics = Topic.page(params[:page]).order(comments_count: :desc).per(20)
    else
      @topics = Topic.page(params[:page]).per(20).order(:id)
    end
    @categories = Category.all 
  end

  def show
    if can_show_topic?(@topic)
      @topic.viewed_count += 1
      @topic.save!
      @topic_comments = @topic.comments.page(params[:page]).per(20)
      @comment = Comment.new
    else
      flash[:alert] = "您無觀看此文章的權限"
      redirect_to root_path
    end
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
    if current_user.admin? || @topic.user.email == current_user.email
      if @topic.destroy
        flash[:alert] = "topic was successfully deleted"
      else
        flash[:alert] = @topic.errors.full_messages.to_sentence
      end
    end
    redirect_to root_path
  end

  def collect
    @topic.collects.create!(user: current_user)
  end

  def uncollect
    collects = Collect.where(topic: @topic, user: current_user)
    collects.destroy_all
  end

  def feeds
    @all_users_count = User.all.count
    @all_posts_count = Topic.all.count
    @all_comments_count = Comment.all.count
    @users = User.order(comments_count: :desc).take(10)
    @topics = Topic.order(comments_count: :desc).take(10)
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :image, :viewed_count, :audience_id, category_ids: [])
  end

  def authenticate_current_user
    unless @topic.user == current_user
      flash[:alert] = "非本人文章，沒有權限!"
      redirect_to root_path
    end
  end

  def can_show_topic?(topic)
    if topic.audience_id == 1 || topic.user_id == current_user.id
      return true
    elsif topic.audience_id == 2
      return User.find_by_id(topic.user_id).all_friends.include?(current_user) ? true : false
    else
      return false
    end
  end
end
