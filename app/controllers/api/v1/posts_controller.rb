class Api::V1::PostsController < ApiController
  before_action :set_topic, except: [:index, :create]
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

  def update
    if @post.user == current_user
      if @post.update(topic_params)
        render json: {
          message: "Topic updated successfully!",
          result: @post
        }
      else
        render json: {
          errors: @post.errors
        }
      end
    else
      render json: {
        message: "非本人文章!"
      }
    end
  end

  def destroy
    if current_user.admin? || @post.user == current_user
      if @post.destroy
        render json: {
          message: "Topic destroy successfully!"
        }
      else
        render json: {
          errors: @post.errors
        }
      end
    else
      render json: {
        message: "非本人文章!"
      }
    end
  end

  private
  
  def set_topic
    @post = Topic.find(params[:id])
  end

  def topic_params
    params.permit(:title, :content, :image, :audience_id, category_ids: [])
  end

end
