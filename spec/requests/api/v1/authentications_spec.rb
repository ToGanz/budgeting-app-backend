require 'rails_helper'

RSpec.describe "Api::V1::Authentications", type: :request do
  describe "POST /auth/login" do
    # initialize test data
    let!(:user) { create(:user) }

    # set test valid and invalid credentials
    let(:valid_credentials) do
      { 
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    let(:invalid_credentials) do
      {
        user: {
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
      }
    end

    context 'when request is valid' do
      before { post "/api/v1/auth/login", params: valid_credentials }

      it 'returns an authentication token' do
        json_response = JSON.parse(response.body)
        expect(json_response['auth_token']).not_to be_nil
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

    end

    context 'when request is invalid' do
      before { post "/api/v1/auth/login", params: invalid_credentials }

      it 'returns a failure message' do
        json_response = JSON.parse(response.body)
        expect(response.body).to match(/Invalid credentials/)
      end

      it "returns http unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
      
    end

  end

end
