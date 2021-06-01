class Api::V1::UsersController < ApplicationController
  skip_before_action :check_login, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def show
    render json: UserSerializer.new(@user).serializable_hash.to_json, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity 
    end
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end

end
