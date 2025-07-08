# spec/requests/sessoes_spec.rb

require 'rails_helper'

RSpec.describe "Sessoes", type: :request do
  let!(:usuario_comum) { create(:usuario, email: 'comum@exemplo.com', password: 'SenhaValida@123', password_confirmation: 'SenhaValida@123') }
  let!(:usuario_admin) { create(:usuario, :admin, email: 'admin@exemplo.com', password: 'SenhaValida@123', password_confirmation: 'SenhaValida@123') }
  let!(:usuario_inativo) { create(:usuario, :novo, email: 'inativo@exemplo.com', password: 'SenhaValida@123', password_confirmation: 'SenhaValida@123') }

  describe "GET /login" do
    it "renderiza a página de login com sucesso" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    context "com credenciais válidas" do
      it "redireciona um usuário comum para a página inicial" do
        post login_path, params: { email: 'comum@exemplo.com', password: 'SenhaValida@123' }
        expect(response).to redirect_to(root_path)
      end

      it "redireciona um admin para o painel de admin" do
        post login_path, params: { email: 'admin@exemplo.com', password: 'SenhaValida@123' }
        expect(response).to redirect_to(admin_path)
      end

      it "redireciona um usuário inativo para a página de troca de senha" do
        post login_path, params: { email: 'inativo@exemplo.com', password: 'SenhaValida@123' }
        expect(response).to redirect_to(redefinir_senha_path)
      end
    end

    context "com credenciais inválidas" do
      it "re-renderiza a página de login" do
        post login_path, params: { email: 'comum@exemplo.com', password: 'senha_errada' }
        expect(response).to render_template(:new)
        expect(response.body).to include("Email ou senha inválidos!")
      end
    end
  end

  describe "DELETE /logout" do
    it "faz o logout do usuário e redireciona para a página de login" do
      post login_path, params: { email: 'comum@exemplo.com', password: 'SenhaValida@123' }
      
      delete logout_path
      expect(response).to redirect_to(login_path)
    end
  end
end
