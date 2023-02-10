require 'rails_helper'

RSpec.describe "ArchivedTweets", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/archived_tweets/create"
      expect(response).to have_http_status(:success)
    end
  end

end
