class TopicsController < ApplicationController
  before_action :set_topic, only: [:show]
  before_action :authenticate_user!, except: :index

  def index
    @topics = Topic.all
  end

  def show
    @topic.viewed_count += 1
    @topic.save!
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save
      flash[:notice] = "topic was successfully created"
      redirect_to root_path
    else
      flash.now[:alert] = "topic was failed to create"
      render :new
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :viewed_count, category_ids: [])
  end
end
