require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  # Initialize the test data
  let!(:plan) { create(:plan) }
  let!(:transactions) { create_list(:transaction, 20, plan_id: plan.id) }
  let(:plan_id) { plan.id }
  let(:id) { transactions.first.id }

  # index
  describe "GET /plans/:plan_id/transactions" do
    # make HTTP get request before each example
    before { get "/api/v1/plans/#{plan_id}/transactions"  }

    context 'when plan exists' do

      it 'returns transactions' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response.size).to eq(20)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when plan does not exist' do
      let(:plan_id) { 0 }

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
    before { get "/api//v1/plans/#{plan_id}/transactions/#{id}"}

    context 'when the record exists' do
      it 'returns the plan' do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(id)
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


end
