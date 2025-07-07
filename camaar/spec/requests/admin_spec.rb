require 'rails_helper'

RSpec.describe "Acesso à área de gerenciamento", type: :request do
  describe "GET /admin" do
    context "Usuário tem perfil de administrador" do
   
    before do
      usuario = create(:usuario, :admin)
      post "/login_para_teste", params: {email: usuario.email}
    end

      it "renderiza a página \"Gerenciamento\" com sucesso" do
        get admin_path
        expect(response).to render_template(:index)
      end
    end

    context "Usuário não tem perfil de administrador" do
      
      before do
        usuario = create(:usuario, e_admin: false)
        post "/login_para_teste", params: {email: usuario.email}
      end

      it "redireciona para página \"Avaliações\"" do
        get admin_path
        expect(response).to redirect_to(root_path)
      end

      it "mostra mensagem de acesso negado" do
        get admin_path
        follow_redirect!
        expect(flash[:alert]).to eq("Acesso restrito a administradores!")
      end
    end
  end
end

RSpec.describe "Importação de dados", type: :request do

  before do
      usuario = create(:usuario, :admin)
      post "/login_para_teste", params: {email: usuario.email}
  end
  describe "POST /importar_dados" do
    context "quando ainda não existem dados no sistema" do
      before do
        Disciplina.delete_all
        Turma.delete_all
        Usuario.where(e_admin: false).delete_all
        ActionMailer::Base.deliveries.clear
        post importar_dados_path
      end

      it "realiza a importação de dados" do
        expect(Disciplina.count).to be > 0
        expect(Turma.count).to be > 0
        expect(Usuario.where(e_admin: false).count).to be > 0
      end

      it "envia um e-mail para cada usuário criado" do
        usuarios = Usuario.where(e_admin: false)
        emails = ActionMailer::Base.deliveries

        expect(emails.count).to eq(usuarios.count)
        usuarios.each do |usuario|
          expect(emails.map(&:to)).to include([usuario.email])
        end
      end

      it "redireciona para a página \"Gerenciamento\"" do
        expect(response).to redirect_to(admin_path)
      end

      it "exibe mensagem de sucesso" do
        follow_redirect!
        expect(flash[:notice]).to eq("Dados importados com sucesso!")
      end
    end

    context "quando já existem dados importados" do
      before do
        create(:turma)
        create_list(:usuario, 5, ocupacao: "discente")
      end

      context "e sobrescrita ainda não foi autorizada" do
        before { post importar_dados_path }

        it "renderiza a página \"Gerenciamento\"" do
          follow_redirect!
          expect(response).to render_template(:index)
        end
     # Trecho elimando porque RSPec não dá suporte a teste de elementos manipulados por JS (como modal, no caso)
     #   it "exibe mensagem de confirmação de sobrescrita" do
     #     expect(response.body).to include("Dados já importados anteriormente!")
     #   end
      end

      context "e sobrescrita foi confirmada" do
        before do
          post importar_dados_path, params: { sobrescrever: true }
        end

        it "realiza a sobrescrita dos dados" do
          expect(Disciplina.count).to be > 0
          expect(Turma.count).to be > 0
          expect(Usuario.where(e_admin: false).count).to be > 0
        end

        it "redireciona para a página \"Gerenciamento\"" do
          expect(response).to redirect_to(admin_path)
        end

        it "exibe mensagem de atualização no flash" do
          follow_redirect!
          expect(flash[:notice]).to eq("Dados atualizados com sucesso!")
        end
      end
    end
  end
end


RSpec.describe "Disponibilidade de dados", type: :request do

  before do
    usuario = create(:usuario, :admin)
    post "/login_para_teste", params: {email: usuario.email}
    Disciplina.delete_all
    Turma.delete_all
    Usuario.where(e_admin: false).delete_all
  end

  it "simula JSON inexistente e redireciona com alerta" do
    allow(File).to receive(:exist?).and_return(false)

    post importar_dados_path

    expect(response).to redirect_to(admin_path)
    follow_redirect!
    expect(flash[:alert]).to eq("Dados indisponíveis no momento! Tente novamente mais tarde ou entre em contato com o suporte técnico.")
  end
end

=begin Testes nativos do RSpec

RSpec.describe "Admins", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /importar_dados" do
    it "returns http success" do
      get "/admin/importar_dados"
      expect(response).to have_http_status(:success)
    end
  end
end
=end
