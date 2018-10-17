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

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :content, :viewed_count, :audience_id, category_ids: [])
  end
end
