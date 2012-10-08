class Api::V1::PostsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  # GET /api/v1/posts.json
  def index
    @posts = Post.all
  end

  # GET /api/v1/posts/:id.json
  def show
    unless @post = Post.find_by_uuid(params[:id])
      render json: {}, status: 404
    end
  end

end
