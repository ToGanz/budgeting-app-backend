class Api::V1::TransactionsController < ApplicationController
  before_action :set_plan
  before_action :set_transaction, only: [:show, :update, :destroy]
  before_action :check_owner

  def index
    transactions = @plan.transactions
    render json: transactions, status: :ok
  end

  def show
    render json: @transaction, status: :ok
  end

  def create
    transaction = @plan.transactions.build(transaction_params)

    if transaction.save
      render json: transaction, status: :created
    else
      render json: { errors: transaction.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      render json: @transaction, status: :ok
    else
      render json: { errors: @transaction.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    head :no_content
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def set_transaction
    @transaction = @plan.transactions.find_by!(id: params[:id]) if @plan
  end

  def transaction_params
    params.require(:transaction).permit(:description, :amount, :category_id)
  end

  def check_owner
    head :forbidden unless @plan.user_id == current_user&.id
  end
end
