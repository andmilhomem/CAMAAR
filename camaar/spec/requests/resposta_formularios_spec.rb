require 'rails_helper'

=begin Testes nativos do RSpec

RSpec.describe "RespostaFormularios", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/resposta_formularios/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/resposta_formularios/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/resposta_formularios/create"
      expect(response).to have_http_status(:success)
    end
  end

end

=end