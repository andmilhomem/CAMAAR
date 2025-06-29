require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/formularios/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/formularios/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/formularios/create"
      expect(response).to have_http_status(:success)
    end
  end

end
