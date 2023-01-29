require 'rails_helper'

RSpec.describe "Onboarding::TwitterAccounts", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/onboarding/twitter_accounts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/onboarding/twitter_accounts/create"
      expect(response).to have_http_status(:success)
    end
  end

end
