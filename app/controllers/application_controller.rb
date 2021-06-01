class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from JWT::DecodeError, with: :decode_error

  before_action :check_login

  def current_user
    return @current_user if @current_user 

    header = request.headers['Authorization']
    return nil if header.nil?

    decoded = JsonWebToken.decode(header)

    @current_user = User.find(decoded[:user_id]) rescue ActiveRecord::RecordNotFound
  end

  private

  def check_login
    head :forbidden unless self.current_user
  end

  def not_found_error(e)
    render json: { errors: e.to_s }, status: :not_found
  end

  def decode_error(e)
    render json: { errors: e.to_s }, status: :unprocessable_entity
  end
end
