require 'rails_helper'

=begin Testes nativos do RSpec

RSpec.describe "Senhas", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/senhas/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/senhas/create"
      expect(response).to have_http_status(:success)
    end
  end

end

=end