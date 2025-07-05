require 'rails_helper'

RSpec.describe "Acesso à área de gerenciamento", type: :request do
  describe "GET /admin" do
    context "Usuário tem perfil de administrador" do
      let(:usuario) { create(:usuario, :admin) }

      before do
        allow_any_instance_of(ActionDispatch::Request)
          .to receive(:session)
          .and_return({ usuario_id: usuario.id })
      end

      it "renderiza a página \"Gerenciamento\" com sucesso" do
        get admin_path
        expect(response).to render_template(:index)
      end
    end

    context "Usuário não tem perfil de administrador" do
      let(:usuario) { create(:usuario, e_admin: false) }

      before do
        allow_any_instance_of(ActionDispatch::Request)
          .to receive(:session)
          .and_return({ usuario_id: usuario.id })
      end

      it "redireciona para página \"Avaliações\"" do
        get admin_path
        expect(response).to redirect_to(formularios_path)
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
  let(:admin) { create(:usuario, :admin) }

  before do
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:session)
      .and_return({ usuario_id: admin.id })
  end

  describe "POST /importar_dados" do
    context "quando ainda não existem dados no sistema" do
      before do
        Disciplina.delete_all
        Turma.delete_all
        Usuario.where(ocupacao: "discente").delete_all
        ActionMailer::Base.deliveries.clear
        post importar_dados_path
      end

      it "realiza a importação de dados" do
        expect(Disciplina.count).to be > 0
        expect(Turma.count).to be > 0
        expect(Usuario.where(ocupacao: "discente").count).to be > 0
      end

      it "envia um e-mail para cada discente criado" do
        discentes = Usuario.where(ocupacao: "discente")
        emails = ActionMailer::Base.deliveries

        expect(emails.count).to eq(discentes.count)
        discentes.each do |usuario|
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
          expect(response).to render_template(:index)
        end

        it "exibe mensagem de confirmação de sobrescrita" do
          expect(response.body).to include("Dados já importados anteriormente!")
        end
      end

      context "e sobrescrita foi confirmada" do
        before do
          post importar_dados_path, params: { sobrescrever: true }
        end

        it "realiza a sobrescrita dos dados" do
          expect(Disciplina.count).to be > 0
          expect(Turma.count).to be > 0
          expect(Usuario.where(ocupacao: "discente").count).to be > 0
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
  let(:admin) { create(:usuario, :admin) }

  before do
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:session)
      .and_return({ usuario_id: admin.id })
    Disciplina.delete_all
    Turma.delete_all
    Usuario.where(ocupacao: "discente").delete_all
  end

  it "simula JSON inexistente e redireciona com alerta" do
    allow(File).to receive(:exist?).with(/\.json$/).and_return(false)

    post importar_dados_path

    expect(response).to redirect_to(admin_path)
    follow_redirect!
    expect(flash[:alert]).to eq("Dados indisponíveis no momento! Tente novamente mais tarde ou entre em contato com o suporte técnico.")
  end
end

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
