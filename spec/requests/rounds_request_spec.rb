require 'rails_helper'

RSpec.describe "Rounds", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/rounds/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/rounds/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/rounds/create"
      expect(response).to have_http_status(:success)
    end
  end

end
