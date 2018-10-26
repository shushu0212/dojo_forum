class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index
  def index
    @posts = Topic.all
    render json: {
      data: @posts
    }
  end

  def show
    @post = Topic.find_by(id: params[:id])
    if !@post
      render json: {
        message: "Can't find the post!",
        status: 400
      }
    else
      render json: {
        data: @post
      }
    end
  end

  def create
    @post = current_user.topics.build(topic_params)
    if @post.save
      render json: {
        message: "Topic created successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end
  
  private
  
  def topic_params
    params.permit(:title, :content, :image, :audience_id, category_ids: [])
  end

end
