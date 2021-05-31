require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
    #initialize test data
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:categories) { create_list(:category, 5, user_id: user.id) }
    let(:category_id) { categories.first.id}
    let(:valid_headers) { { Authorization: JsonWebToken.encode(user_id: user.id) } }

    # index
    describe "GET /categories" do
      context 'when not logged in' do
        before { get '/api/v1/categories' }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end

      end

      context 'when logged in' do

        before do 
          get '/api/v1/categories', headers: valid_headers
        end
    
        it 'returns categories' do
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
    describe "GET /categories/:id" do

      context 'when not logged in' do
        before { get "/api//v1/categories/#{category_id}" }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when logged in as wrong user' do
        before { get "/api//v1/categories/#{category_id}", headers: { Authorization: JsonWebToken.encode(user_id: user2.id) } }
  
        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
  
      context 'when the record exists' do
        before { get "/api//v1/categories/#{category_id}", headers: valid_headers }

        it 'returns the category' do
          json_response = JSON.parse(response.body)
          expect(json_response).not_to be_empty
          expect(json_response['id']).to eq(category_id)
        end
  
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
  
      context 'when the record does not exist' do
        let(:category_id) { 100 }
        before { get "/api//v1/categories/#{category_id}", headers: valid_headers }
  
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
  
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Category/)
        end
      end
  
    end
  
    # create
    describe 'POST /categories' do
      # valid payload
      let(:valid_attributes) { { category: { name: 'Job' } } }
  
      context 'when not logged in' do
        before { post '/api/v1/categories', params: valid_attributes }
  
        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when the request is valid' do
        before { post '/api/v1/categories', params: valid_attributes, headers: valid_headers }
  
        it 'creates a category' do
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq('Job')
        end
  
        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end
  
      context 'when the request is invalid' do
        before { post '/api/v1/categories', params: { category: { name: '' } }, headers: valid_headers }
  
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
  
        it 'returns a validation failure message' do
          expect(response.body).to match(/can't be blank/)
        end
      end
    end
  
    # update
    describe 'PUT /categories/:id' do
      let(:valid_attributes) { { category: { name: 'Shopping' } } }
  
      context 'when not logged in' do
        before { put "/api/v1/categories/#{category_id}", params: valid_attributes }
  
        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
  
      context 'when logged in as wrong user' do
        before do 
          put("/api//v1/categories/#{category_id}", 
            params: valid_attributes, 
            headers: { Authorization: JsonWebToken.encode(user_id: user2.id) } 
          )
        end
  
        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when the record exists' do
        before { put "/api/v1/categories/#{category_id}", params: valid_attributes, headers: valid_headers }
  
        it 'updates the record' do
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq('Shopping')
        end
  
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
  
      context 'when the request is invalid' do
        before { put "/api/v1/categories/#{category_id}", params: { category: { name: '' } }, headers: valid_headers }
  
        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
  
        it 'returns a validation failure message' do
          expect(response.body).to match(/can't be blank/)
        end
      end
  
      context 'when the record does not exist' do
        before { put "/api/v1/categories/#{100}", params: valid_attributes, headers: valid_headers }
  
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
  
        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Category/)
        end
      end
    end
    
    # destroy
    describe 'DELETE /categories/:id' do
      context 'when not logged in' do
        before { delete "/api/v1/categories/#{category_id}" }
  
        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
  
      context 'when logged in as wrong user' do
        before do 
          delete("/api//v1/categories/#{category_id}", 
            headers: { Authorization: JsonWebToken.encode(user_id: user2.id) } 
          )
        end
  
        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when logged in' do
        before { delete "/api/v1/categories/#{category_id}", headers: valid_headers }
    
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

    end
    
end
