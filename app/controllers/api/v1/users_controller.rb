class Api::V1::UsersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource only: [:index, :show]

  # GET /api/v1/users.json
  def index
    @users = User.all
  end

  # GET /api/v1/users/:id.json
  def show
    unless @user = User.find_by_uuid(params[:id])
      render json: nil, status: 404
    end
  end

  # GET /api/v1/users/me.json
  def me
    @user = current_user
    render 'api/v1/users/show'
  end
end
