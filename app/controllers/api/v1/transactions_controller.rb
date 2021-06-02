class Api::V1::TransactionsController < ApplicationController
  include Paginable

  before_action :set_plan
  before_action :set_transaction, only: [:show, :update, :destroy]
  before_action :check_owner

  def index
    transactions = @plan.transactions.page(current_page).per(per_page)
    options = {
      links: {
        first: api_v1_plan_transactions_path(page: 1),
        last: api_v1_plan_transactions_path(page: transactions.total_pages), 
        prev: api_v1_plan_transactions_path(page: transactions.prev_page), 
        next: api_v1_plan_transactions_path(page: transactions.next_page),
      }
    }

    render json: serialize(transactions, options), status: :ok
  end

  def show
    render json: serialize(@transaction), status: :ok
  end

  def create
    transaction = @plan.transactions.build(transaction_params)

    if transaction.save
      render json: serialize(transaction), status: :created
    else
      render json: { errors: transaction.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      render json: serialize(@transaction), status: :ok
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

  def serialize(object, options = {})
    TransactionSerializer.new(object, options).serializable_hash.to_json
  end
end
