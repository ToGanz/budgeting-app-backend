class Api::V1::TransactionsController < ApplicationController
  before_action :set_plan
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    transactions = @plan.transactions
    render json: transactions, status: :ok
  end

  def show
    render json: @transaction, status: :ok
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def set_transaction
    @transaction = @plan.transactions.find_by!(id: params[:id]) if @plan
  end
end
