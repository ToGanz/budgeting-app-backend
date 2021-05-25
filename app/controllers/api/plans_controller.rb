class Api::PlansController < ApplicationController

  def index
    @plans = Plan.all
    render json: @plans, status: status
  end
end
