require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  # Initialize the test data
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:plan) { create(:plan, user_id: user.id) }
  let!(:category) { create(:category, user_id: user.id) }
  let!(:transactions) { create_list(:transaction, 20, plan_id: plan.id) }
  let(:plan_id) { plan.id }
  let(:id) { transactions.first.id }
  let(:transaction) { transactions.first }
  let(:valid_headers) { { Authorization: JsonWebToken.encode(user_id: user.id) } }

  # index
  describe "GET /plans/:plan_id/transactions" do
    context 'when not logged in' do
      before { get "/api/v1/plans/#{plan_id}/transactions" }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when logged in as wrong user' do
      before do 
        get("/api/v1/plans/#{plan_id}/transactions",
          headers: { Authorization: JsonWebToken.encode(user_id: user2.id) } 
        )
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when plan exists' do
      before { get "/api/v1/plans/#{plan_id}/transactions", headers: valid_headers  }

      it 'returns transactions' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response).not_to be_empty
        expect(json_response.dig(:data).size).to eq(20)
        expect(json_response.dig(:links, :first)).to eq("/api/v1/plans/#{plan_id}/transactions?page=1")
        expect(json_response.dig(:links, :last)).to eq("/api/v1/plans/#{plan_id}/transactions?page=1")
        expect(json_response.dig(:links, :prev)).to eq("/api/v1/plans/#{plan_id}/transactions")
        expect(json_response.dig(:links, :next)).to eq("/api/v1/plans/#{plan_id}/transactions")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with pagination' do
      before do 
        get("/api/v1/plans/#{plan_id}/transactions", 
          params: { page: 1, per_page: 5 }, 
          headers: valid_headers
        )
      end

      it 'returns pagination links' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response.dig(:links, :first)).to eq("/api/v1/plans/#{plan_id}/transactions?page=1")
        expect(json_response.dig(:links, :last)).to eq("/api/v1/plans/#{plan_id}/transactions?page=4")
        expect(json_response.dig(:links, :prev)).to eq("/api/v1/plans/#{plan_id}/transactions")
        expect(json_response.dig(:links, :next)).to eq("/api/v1/plans/#{plan_id}/transactions?page=2")
        # assert_not_nil json_response.dig(:links, :last) 
        # assert_not_nil json_response.dig(:links, :prev) 
        # assert_not_nil json_response.dig(:links, :next)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when plan does not exist' do
      let(:plan_id) { 0 }
      before { get "/api/v1/plans/#{plan_id}/transactions", headers: valid_headers  }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Plan/)
      end
    end

  end # end of index

  # show
  describe "GET /plans/:plan_id/transactions/:id" do
    before { get "/api//v1/plans/#{plan_id}/transactions/#{id}", headers: valid_headers }

    context 'when the record exists' do
      it 'returns the transaction' do
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response).not_to be_empty
        expect(json_response.dig(:data, :id)).to eq(id.to_s)
        expect(json_response.dig(:data, :attributes, :description)).to eq(transaction.description)
        expect(json_response.dig(:data, :attributes, :spending)).to eq(transaction.spending)
        expect(json_response.dig(:data, :relationships, :category, :data, :id)).to eq(transaction.category.id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Transaction/)
      end
    end

  end # end of show

  # create
  describe 'POST /plans/:plan_id/transactions' do
    # valid payload
    let(:valid_attributes) do 
      { transaction: { 
          description: 'Groceries',
          amount: "12.00",
          category_id: category.id
        } 
      } 
    end

    context 'when the request is valid' do
      before { post "/api/v1/plans/#{plan_id}/transactions", params: valid_attributes, headers: valid_headers }

      it 'creates a transaction' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['description']).to eq('Groceries')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/api/v1/plans/#{plan_id}/transactions", params: { transaction: { description: '' } }, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end
  end # end of create

  # update
  describe 'PUT /plans/:plan_id/transactions/:id' do
    let(:valid_attributes) { { transaction: { description: 'Shopping' } } }

    context 'when the record exists' do
      before { put "/api/v1/plans/#{plan_id}/transactions/#{id}", params: valid_attributes, headers: valid_headers }

      it 'updates the record' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']['description']).to eq('Shopping')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put "/api/v1/plans/#{plan_id}/transactions/#{id}", params: { transaction: { description: '' } }, headers: valid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/can't be blank/)
      end
    end

    context 'when the record does not exist' do
      before { put "/api/v1/plans/#{plan_id}/transactions/#{100}", params: valid_attributes, headers: valid_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Transaction/)
      end
    end
  end # end of update

  # destroy
  describe 'DELETE /plans/:plan_id/transactions/:id' do
    before { delete "/api/v1/plans/#{plan_id}/transactions/#{id}", headers: valid_headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
