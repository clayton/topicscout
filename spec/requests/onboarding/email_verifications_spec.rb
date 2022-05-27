require 'rails_helper'

RSpec.describe "Onboarding::EmailVerifications", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/onboarding/email_verifications/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
