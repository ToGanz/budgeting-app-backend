require 'rails_helper'

RSpec.describe "Api::Plans", type: :request do
  #initialize test data
  let!(:plans) { create_list(:plan, 5) }

  describe "GET /api/plans" do
    # make HTTP get request before each example
    before do 
      get '/api/plans' 
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
