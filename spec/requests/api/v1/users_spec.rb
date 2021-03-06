require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  #initialize test data
  let!(:users) { create_list(:user, 5) }
  let(:user_id) { users.first.id}
  let(:valid_headers) { { Authorization: JsonWebToken.encode(user_id: user_id) } }

  # show
  describe "GET /users/:id" do
    before { get "/api//v1/users/#{user_id}"}

    context 'when not logged in' do
      before { get "/api//v1/users/#{user_id}"}

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record exists' do
      before { get "/api//v1/users/#{user_id}", headers: valid_headers }

      it 'returns the user' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response['data']['id']).to eq(user_id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }
      before { get "/api//v1/users/#{user_id}", headers: valid_headers }

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
        expect(json_response['data']['attributes']['name']).to eq('tobi')
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

  # update
  describe 'PUT /users/:id' do
    let(:valid_attributes) do 
      { 
        user: { 
          name: 'thilo'
        } 
      } 
    end

    context 'when not authorized' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes }

      it 'returns forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the record exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes, headers: valid_headers }

      it 'updates the record' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['name']).to eq('thilo')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put "/api/v1/users/#{user_id}", params: { user: { name: '' } }, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context 'when the record does not exist' do
      before { put "/api/v1/users/#{100}", params: valid_attributes, headers: valid_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end # end of update

  # destroy
  describe 'DELETE /plans/:id' do
    context 'when not authorized' do
      before { delete "/api/v1/users/#{user_id}" }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
    
    context 'when authorized' do
      before { delete "/api/v1/users/#{user_id}", headers: valid_headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    
  end # end of destroy

end
