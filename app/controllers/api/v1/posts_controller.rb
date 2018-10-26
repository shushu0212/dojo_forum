class Api::V1::PostsController < ApiController
  def index
    @posts = Topic.all
    render json: {
      data: @posts
    }
  end
end
