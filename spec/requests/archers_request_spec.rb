require 'rails_helper'

RSpec.describe "Archers", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/archers/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/archers/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/archers/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/archers/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/archers/update"
      expect(response).to have_http_status(:success)
    end
  end

end
