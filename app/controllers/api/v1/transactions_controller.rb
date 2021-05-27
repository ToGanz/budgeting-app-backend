class Api::V1::TransactionsController < ApplicationController
  before_action :set_plan

  def index
    transactions = @plan.transactions
    render json: transactions, status: :ok
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end
