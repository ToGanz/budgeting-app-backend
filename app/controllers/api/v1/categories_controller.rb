class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:show, :update, :destroy]

  def index
    categories = current_user.categories
    render json: categories, status: :ok
  end

  def show
    render json: @category, status: :ok
  end

  def create
    category = current_user.categories.build(category_params)

    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { errors: @category.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def check_owner
    head :forbidden unless @category.user_id == current_user&.id
  end
end
