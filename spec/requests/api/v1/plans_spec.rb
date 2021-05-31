require 'rails_helper'

RSpec.describe "Api::V1::Plans", type: :request do
  # initialize test data
  let(:user) { create(:user) }
  let!(:plans) { create_list(:plan, 5, user_id: user.id) }
  let(:plan_id) { plans.first.id}
  let(:valid_headers) { { Authorization: JsonWebToken.encode(user_id: user.id) } }

  # index
  describe "GET /plans" do
    context 'when not logged in' do
      before do 
        get '/api/v1/plans'
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when logged in' do
      before do 
        get '/api/v1/plans', headers: valid_headers
      end

      it 'returns plans' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

  end

  # show
  describe "GET /plans/:id" do
    before { get "/api//v1/plans/#{plan_id}", headers: valid_headers }

    context 'when not logged in' do
      before { get "/api//v1/plans/#{plan_id}" }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record exists' do
      it 'returns the plan' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(plan_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:plan_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end

  end

  # create
  describe 'POST /plans' do
    # valid payload
    let(:valid_attributes) { { plan: { title: 'Personal Finance' } } }

    context 'when not logged in' do
      before { post '/api/v1/plans', params: valid_attributes }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the request is valid' do
      before { post '/api/v1/plans', params: valid_attributes, headers: valid_headers }

      it 'creates a plan' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Personal Finance')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/plans', params: { plan: { title: '' } }, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

  # update
  describe 'PUT /plans/:id' do
    let(:valid_attributes) { { plan: { title: 'Shopping' } } }

    context 'when not logged in' do
      before { put "/api/v1/plans/#{plan_id}", params: valid_attributes }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record exists' do
      before { put "/api/v1/plans/#{plan_id}", params: valid_attributes, headers: valid_headers }

      it 'updates the record' do
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to eq('Shopping')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put "/api/v1/plans/#{plan_id}", params: { plan: { title: '' } }, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context 'when the record does not exist' do
      before { put "/api/v1/plans/#{100}", params: valid_attributes, headers: valid_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end
  end
  
  # destroy
  describe 'DELETE /plans/:id' do
    context 'when not logged in' do
      before { delete "/api/v1/plans/#{plan_id}" }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when logged in' do
      before { delete "/api/v1/plans/#{plan_id}", headers: valid_headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

  end
  
end
