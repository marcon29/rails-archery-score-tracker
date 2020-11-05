require 'rails_helper'

RSpec.describe "Statics", type: :request do

  describe "GET /home" do
    it "returns http success" do
      get "/static/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get "/static/about"
      expect(response).to have_http_status(:success)
    end
  end

end
