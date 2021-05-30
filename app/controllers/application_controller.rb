class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_error

  def current_user
    return @current_user if @current_user 

    header = request.headers['Authorization']
    return nil if header.nil?

    decoded = JsonWebToken.decode(header)

    @current_user = User.find(decoded[:user_id]) rescue ActiveRecord::RecordNotFound
  end

  private

  def handle_error(e)
    render json: { errors: e.to_s }, status: :not_found
  end
end
