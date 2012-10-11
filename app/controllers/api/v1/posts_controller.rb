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
      render json: nil, status: 404
    end
  end

  # PUT /api/v1/posts/:id.json
  def update
    render(json: nil, status: 422) and return unless post_params = params['post']
    post_params.slice!('title', 'body')

    @post = current_user.posts.find_or_initialize_by_uuid(params[:id])
    status_code = @post.new_record? ? 201 : 200

    if @post.update_attributes(post_params)
      render 'api/v1/posts/show', status: status_code
    else
      render json: { errors: { post: @post.errors } }, status: 422
    end
  end

  # DELETE /api/v1/posts/:id.json
  def destroy
    if post = current_user.posts.find_by_uuid(params[:id])
      post.destroy
      render json: nil, status: 200
    else
      render json: nil, status: 404
    end
  end
end
