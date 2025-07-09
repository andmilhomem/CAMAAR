require 'rails_helper'

=begin Testes nativos do RSpec

RSpec.describe "Templates", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/templates/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/templates/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/templates/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/templates/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/templates/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/templates/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'acesso restrito a admin' do
    let(:admin) { Usuario.create!(nome: 'Admin', formacao: 'Doutor', ocupacao: 'docente', num_usuario: 1, email: 'admin@admin.com', e_admin: true, esta_ativo: true, password: '123456', password_confirmation: '123456') }
    let(:usuario) { Usuario.create!(nome: 'User', formacao: 'Graduando', ocupacao: 'discente', num_usuario: 2, email: 'user@user.com', e_admin: false, esta_ativo: true, password: '123456', password_confirmation: '123456') }

    it 'permite admin acessar index' do
      post login_path, params: { email: admin.email, password: '123456' }
      get templates_path
      expect(response).to have_http_status(:success)
    end

    it 'não permite usuário comum acessar index' do
      post login_path, params: { email: usuario.email, password: '123456' }
      get templates_path
      expect(response).to redirect_to(login_path)
    end
  end

end

=end