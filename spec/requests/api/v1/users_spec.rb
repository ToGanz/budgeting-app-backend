require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  #initialize test data
  let!(:users) { create_list(:user, 5) }
  let(:user_id) { users.first.id}

  # show
  describe "GET /users/:id" do
    before { get "/api//v1/users/#{user_id}"}

    context 'when the record exists' do
      it 'returns the user' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end

  end # end of show

  # create
  describe 'POST /users' do
    # valid payload
    let(:valid_attributes) do 
      { 
        user: { 
          name: 'tobi', 
          email: 'test@test.com',
          password: 'password',
        } 
      } 
    end

    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }

      it 'creates a user' do
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('tobi')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/api/v1/users', 
          params: { 
            user: { 
              name: '', 
              email: 'test@test.com',
              password: 'password'
            } 
          }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context 'when the email is taken' do
      before do
        post '/api/v1/users', 
          params: { 
            user: { 
              name: 'tobi', 
              email: users.first.email,
              password: 'password'
            } 
          }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/has already been taken/)
      end
    end
  end # end of create

end
