require 'rails_helper'

RSpec.describe "Acesso a áreas restritas", type: :request do
  describe "GET formularios_path" do
    context "Usuário com senha provisória" do
      
      before do
        usuario = create(:usuario, :novo)
        post "/login_para_teste", params: {email: usuario.email}
      end

      it "redireciona para página \"Redefinição de senha\"" do
        get formularios_path
        expect(response).to redirect_to(redefinir_senha_path)
      end

      it "mostra mensagem com alerta sobre redefinição de senha" do
        get formularios_path
        follow_redirect!
        expect(flash[:alert]).to eq("Você precisa redefinir sua senha!")
      end
    end

    context "Usuário não está logado" do

      it "redireciona para página \"Login\"" do
        get formularios_path
        expect(response).to redirect_to(login_path)
      end

      it "mostra mensagem com alerta sobre necessidade de autenticação" do
        get formularios_path
        follow_redirect!
        expect(flash[:alert]).to eq("Você precisa estar logado!")
      end
    end
  end
end
