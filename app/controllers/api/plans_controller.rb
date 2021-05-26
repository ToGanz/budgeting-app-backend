class Api::PlansController < ApplicationController
  before_action :set_plan, only: [:show]
  
  def index
    @plans = Plan.all
    render json: @plans, status: :ok
  end

  def show
    render json: @plan, status: :ok
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end
end
