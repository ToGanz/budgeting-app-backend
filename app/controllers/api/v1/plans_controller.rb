class Api::V1::PlansController < ApplicationController
  before_action :set_plan, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:show, :update, :destroy]

  def index
    plans = current_user.plans
    render json: serialize(plans), status: :ok
  end

  def show
    render json: serialize(@plan), status: :ok
  end

  def create
    plan = current_user.plans.build(plan_params)

    if plan.save
      render json: serialize(plan), status: :created
    else
      render json: { errors: plan.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @plan.update(plan_params)
      render json: serialize(@plan), status: :ok
    else
      render json: { errors: @plan.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    head :no_content
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title)
  end

  def check_owner
    head :forbidden unless @plan.user_id == current_user&.id
  end

  def serialize(object)
    PlanSerializer.new(object).serializable_hash.to_json
  end
end
