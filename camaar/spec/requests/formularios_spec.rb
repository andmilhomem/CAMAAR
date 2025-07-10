require 'rails_helper'

# begin Testes nativos do RSpec

RSpec.describe "Formularios", type: :request do

  describe "GET /index" do
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

