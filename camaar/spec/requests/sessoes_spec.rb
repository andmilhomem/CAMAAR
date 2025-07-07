require 'rails_helper'

=begin Testes nativos do RSpec

RSpec.describe "Sessoes", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/sessoes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/sessoes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/sessoes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

=end