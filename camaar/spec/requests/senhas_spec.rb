require 'rails_helper'
RSpec.describe "Senhas", type: :request do
  # Cria um usuário que precisa trocar a senha (inativo)
  let!(:usuario_inativo) { create(:usuario, :novo, password: "SenhaValida@123", password_confirmation: "SenhaValida@123") }

  before do
    # Simula o login do usuário com a senha temporária
    post login_path, params: { email: usuario_inativo.email, password: "SenhaValida@123" }
    expect(response).to redirect_to(redefinir_senha_path)
  end

  describe "GET /redefinir_senha" do
    it "mostra a página de redefinição de senha com sucesso" do
      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Redefinir Senha")
    end
  end

  # Testa a funcionalidade de SALVAR a nova senha
  describe "PATCH /redefinir_senha" do
    context "com dados válidos" do
      it "atualiza a senha, ativa o usuário e redireciona para a página inicial" do
        patch redefinir_senha_path, params: {
          usuario: {
            password: "NovaSenhaForte@2025",
            password_confirmation: "NovaSenhaForte@2025"
          }
        }

        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("Sua senha foi atualizada com sucesso!")
        # Verifica se o usuário foi atualizado
        usuario_inativo.reload
        expect(usuario_inativo.esta_ativo?).to be true
      end
    end

    context "com dados inválidos" do
      it "re-renderiza a página com um erro se as senhas não corresponderem" do
        patch redefinir_senha_path, params: {
          usuario: {
            password: "NovaSenhaForte@2025",
            password_confirmation: "senha_diferente"
          }
        }

        expect(response).to render_template(:edit)
        expect(response.body).to include("Password confirmation doesn&#39;t match Password")
      end

      it "re-renderiza a página com um erro se a senha for muito fraca" do
        patch redefinir_senha_path, params: {
          usuario: {
            password: "fraca",
            password_confirmation: "fraca"
          }
        }

        expect(response).to render_template(:edit)
        expect(response.body).to include("deve conter no mínimo 8 caracteres")
      end
    end
  end
end