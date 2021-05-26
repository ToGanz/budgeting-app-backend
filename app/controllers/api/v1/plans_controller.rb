class Api::V1::PlansController < ApplicationController
  before_action :set_plan, only: [:show, :update]
  
  def index
    plans = Plan.all
    render json: plans, status: :ok
  end

  def show
    render json: @plan, status: :ok
  end

  def create
    plan = Plan.new(plan_params)

    if plan.save
      render json: plan, status: :created
    else
      render json: { errors: plan.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @plan.update(plan_params)
      render json: @plan, status: :ok
    else
      render json: { errors: @plan.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title)
  end
end
