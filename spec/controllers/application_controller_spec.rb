require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  # create test user
  let!(:user) { create(:user) }
   # set headers for authorization
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe "#current_user" do
    context "when auth token is passed" do
      before { allow(request).to receive(:headers).and_return(headers) }

      it "sets the current user" do
        expect(subject.current_user).to eq(user)
      end
    end

    context "when auth token is not passed" do
      before do
        allow(request).to receive(:headers).and_return(invalid_headers)
      end

      it "returns nil" do
        expect(subject.current_user).to eq(nil)
      end
    end
  end
end