class Api::V1::PostsController < ApiController
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
end
