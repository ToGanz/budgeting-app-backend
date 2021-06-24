class Api::V1::AuthenticationsController < ApplicationController
  skip_before_action :check_login
  
  def authenticate
    @user = User.find_by_email(user_params[:email]) 
    if @user && @user.authenticate(user_params[:password])
      render json: {
        auth_token: JsonWebToken.encode(user_id: @user.id),
        id: @user.id,
        email: @user.email,
        name: @user.name
      }
    else
      render json: { errors: 'Invalid credentials.' }, status: :unauthorized
    end
  end

  private

  def user_params 
    params.require(:user).permit(:email, :password)
  end

end
